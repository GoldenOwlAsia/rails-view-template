module Attachable
  extend ActiveSupport::Concern

  private

  def purge_attachments(attachment_ids)
    return if attachment_ids.blank?

    attachment_ids.each do |aid|
      attachment = ActiveStorage::Attachment.find_by(id: aid)
      attachment&.purge
    end
  end
end
