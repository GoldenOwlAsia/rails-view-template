module Currentable
  extend ActiveSupport::Concern

  included do
    before_action :set_request_details, if: :user_signed_in?
  end

  def current_user
    @current_user ||= super.tap do |user|
      ActiveRecord::Associations::Preloader.new(records: [user], associations: :roles).call if user.present?
    end
  end

  private

  def set_request_details
    Current.user = current_user
    Current.ip_address = request.ip
    Current.request_id = request.uuid
    Current.user_agent = request.user_agent
  end
end
