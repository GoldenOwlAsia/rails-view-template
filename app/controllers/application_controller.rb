class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  include Currentable
  include Pagy::Method
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_record
  rescue_from ActionController::RoutingError, with: :rescue_routing_error

  before_action :authenticate_user!

  def self.only_turbo_stream_for(*actions)
    raise ArgumentError, 'force_turbo_stream_for arguments must have least one item' if actions.blank?

    before_action :ensure_turbo_frame_request, only: actions
  end

  def send_flash_message(message:, success: true, now: false)
    type = success ? :notice : :alert
    (now ? flash.now : flash)[type] = message
  end

  def context_view_path(*strs)
    File.join([controller_path].push(*strs))
  end

  private

  def not_authorized
    redirect_back_or_to(root_path, alert: 'You are not authorized to perform this action.')
  end

  def rescue_routing_error
    redirect_to root_path, alert: 'Resource not found'
  end

  def ensure_turbo_frame_request
    head :bad_request unless turbo_frame_request?
  end

  def policy_scope(scope, policy_scope_class: nil)
    super
  end

  def authorize(record, query = nil, policy_class: nil)
    super
  end
end
