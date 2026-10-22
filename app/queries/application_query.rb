# Sample usage:
#
# module Products
#   class Gather < ApplicationQuery
#     def call(scope = Product.all, **params)
#       scope = filter(scope, :by_term, params[:term])
#       scope = filter(scope, :by_price, params[:price])
#       scope = sort(scope, params[:sort])
#       scope
#     end
#
#     private
#
#     def by_term(scope, term)
#       scope.where('name ILIKE ?', "%#{term}%")
#     end
#
#     def by_price(scope, price)
#       scope.where('price <= ?', price)
#     end
#   end
# end
#
# Products::Gather.call(name: 'phone', price: 1000)
# Products::Gather.call(name: 'phone', price: 1000, sort: 'price')
# Products::Gather.call(name: 'phone', price: 1000, sort: '-price')
# Products::Gather.call(Product.on_sale, name: 'phone', price: 1000)
#
class ApplicationQuery
  def self.call(...)
    new.call(...)
  end

  def call(scope = nil, **)
    raise NotImplementedError, "You must define `call` as instance method in #{self.class.name} class."
  end

  private

  def filter(scope, method, params)
    return scope if params.blank?

    send(method, scope, params)
  end

  def sort(scope, sorting)
    return scope if sorting.blank?

    column, direction = extract_sorting(sorting)
    scope.order(column => direction)
  end

  def extract_sorting(value)
    direction = :asc
    column = value

    if value.start_with?('+', '-')
      direction = :desc if value.start_with?('-')
      column = value[1..]
    end

    [column, direction]
  end
end
