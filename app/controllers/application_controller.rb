# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  include Pundit::Authorization
  include Pagy::Backend

  rescue_from Pundit::NotAuthorizedError, with: :not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_record

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
    redirect_back fallback_location: root_path, alert: 'You are not authorized to perform this action.'
  end

  def ensure_turbo_frame_request
    head :bad_request unless turbo_frame_request?
  end
end
