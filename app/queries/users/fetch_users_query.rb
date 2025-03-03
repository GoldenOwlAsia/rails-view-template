module Users
  class FetchUsersQuery < ApplicationQuery
    query_on User

    def call
      relation.extending(Scope, OrderScope)
        .filter_by_created_at(options[:date], '>=')
        .filter_by_email(options[:email])
        .order_by(options[:order_by], options[:order_direction])
    end

    module Scope
      # Just for example, you should add more custom filters here.
      def filter_by_created_at(date, operation)
        return self if date.blank?

        date = date.to_datetime

        where("DATE(users.created_at) #{operation} ?", date)
      end

      def filter_by_email(email)
        return self if email.blank?

        where(email: email)
      end
    end
  end
end
