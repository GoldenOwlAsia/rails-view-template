require 'rails_helper'

RSpec.describe 'Architecture boundaries' do
  def offenses(globs, pattern)
    Array(globs).flat_map { |glob| Rails.root.glob(glob) }.flat_map do |path|
      path.readlines.each_with_index.filter_map do |line, index|
        next unless line.match?(pattern)

        "#{path.relative_path_from(Rails.root)}:#{index + 1} — #{line.strip}"
      end
    end
  end

  def classes_in(layer, except: [])
    Rails.application.eager_load!

    Rails.root.glob("app/#{layer}/**/*.rb").filter_map do |path|
      name = path.relative_path_from(Rails.root.join('app', layer)).to_s.delete_suffix('.rb')
      next if name.start_with?('concerns/')

      constant = name.camelize.safe_constantize
      next if constant.nil? || !constant.is_a?(Class) || except.include?(constant.name)

      constant
    end
  end

  describe 'layers this repo does not have' do
    it 'introduces no parallel layer directory' do
      forbidden = %w[services forms decorators interactors].select { |dir| Rails.root.join('app', dir).exist? }

      message = "app/#{forbidden.join(', app/')} exists. What other codebases call a Service Object " \
                'is an Operation here (app/operations); forms and decorators are deliberately absent. ' \
                'Adding a layer is a decision for the whole team — see ' \
                '.claude/rules/rails-architecture.md, "Layers this repo does not have".'

      expect(forbidden).to be_empty, message
    end
  end

  describe 'controllers' do
    it 'builds strong parameters from app/permit_params, not inline permit lists' do
      found = offenses('app/controllers/**/*.rb', /params\s*(\.require\([^)]*\))?\.permit\b/)

      message = "Inline permit list:\n#{found.join("\n")}\n" \
                'A permitted-attributes list belongs in app/permit_params as a <Resource>Params class, ' \
                'reached with params.expect(...) — see app/permit_params/user_params.rb and ' \
                '.claude/rules/controllers.md.'

      expect(found).to be_empty, message
    end

    it 'does not swallow StandardError' do
      found = offenses('app/controllers/**/*.rb', /rescue\s+StandardError/)

      message = "Blanket rescue:\n#{found.join("\n")}\n" \
                'ApplicationController already rescues Pundit::NotAuthorizedError, RecordNotFound and ' \
                'RoutingError. Rescuing StandardError on top of that hides the failures worth seeing — ' \
                'see .claude/rules/controllers.md.'

      expect(found).to be_empty, message
    end
  end

  describe 'models' do
    it 'dispatches no mail or background work' do
      found = offenses('app/models/**/*.rb', /deliver_later|deliver_now|perform_later|perform_async/)

      message = "Workflow in a model:\n#{found.join("\n")}\n" \
                'Sending mail or enqueuing a job is a workflow and belongs in an Operation ' \
                '(app/operations), not in a model or its callbacks — see ' \
                '.claude/rules/models-and-migrations.md and .claude/rules/rails-transactions.md.'

      expect(found).to be_empty, message
    end
  end

  describe 'views and components' do
    it 'runs no queries from a template' do
      found = offenses(['app/views/**/*.slim', 'app/components/**/*.slim'], /\.where\(|\.find_by|\.pluck\(/)

      message = "Query in a template:\n#{found.join("\n")}\n" \
                'A template renders what it is given. Load the data in the controller, a query object, or ' \
                'a presenter — see .claude/rules/frontend.md.'

      expect(found).to be_empty, message
    end

    it 'runs no queries from a component class' do
      found = offenses('app/components/**/*.rb', /\.where\(|\.find_by|\.pluck\(/)

      message = "Query in a component:\n#{found.join("\n")}\n" \
                'Components take records as arguments so they can be rendered in a spec and a Lookbook ' \
                'preview without a database — see .claude/rules/frontend.md.'

      expect(found).to be_empty, message
    end
  end

  describe 'layer base classes' do
    it 'has every operation inherit ApplicationOperation' do
      strays = classes_in('operations', except: %w[ApplicationOperation]).reject { |k| k < ApplicationOperation }

      message = "#{strays.join(', ')} does not inherit ApplicationOperation, so it does not get " \
                'Responseable and cannot return success(...) / failure(...) like every other operation.'

      expect(strays).to be_empty, message
    end

    it 'has every query inherit ApplicationQuery' do
      strays = classes_in('queries', except: %w[ApplicationQuery]).reject { |k| k < ApplicationQuery }

      message = "#{strays.join(', ')} does not inherit ApplicationQuery, so it lacks the filter/sort " \
                'helpers that give query objects here their shape.'

      expect(strays).to be_empty, message
    end

    it 'has every component inherit ApplicationComponent' do
      strays = classes_in('components', except: %w[ApplicationComponent]).reject { |k| k < ApplicationComponent }

      message = "#{strays.join(', ')} does not inherit ApplicationComponent."

      expect(strays).to be_empty, message
    end
  end
end
