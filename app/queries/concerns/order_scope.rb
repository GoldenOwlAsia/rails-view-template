module OrderScope
  extend ActiveSupport::Concern

  def order_by(column, direction)
    return self if column.blank? || direction.blank?

    order(column => direction)
  end
end
