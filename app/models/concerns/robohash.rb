module Robohash
  extend ActiveSupport::Concern

  module ClassMethods
    attr_accessor :robohash_attributes

    def robohash(attributes)
      raise ArgumentError, 'robohash attributes must have least one item' if attributes.blank?

      self.robohash_attributes = attributes.map(&:to_sym)

      after_save :attach_robohash, unless: -> { Rails.env.test? }
    end
  end

  private

  def attach_robohash
    self.class.robohash_attributes.each do |attr|
      attachment = send(attr)
      next if attachment.attached?

      image = Rails.root.join("app/frontend/images/robohash/robohash_set4_#{rand(1..10)}.png").open
      blob = ActiveStorage::Blob.create_and_upload!(
        io: image,
        content_type: 'image/png',
        filename: "#{SecureRandom.uuid}.png",
        key: ActiveStorage::Blob.generate_unique_secure_token
      )
      attachment.attach(blob)
    end
  end
end
