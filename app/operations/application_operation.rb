# Sample usage:
#
# module Users
#   class Create < ApplicationOperation
#     attr_reader :user

#     def initialize(user = User.new)
#       @user = user
#     end

#     def call(params)
#       ActiveRecord::Base.transaction do
#         user.assign_attributes(params)
#         user.save!

#         success(user) # success(user: user, token: '123')
#       end
#     rescue StandardError => e
#       failure(e.message)
#     end
#   end
# end
#
# response = Users::Create.call(email: 'test@example.com', password: 'Password123@')
# response = Users::Create.new(User.new).call(email: 'test@example.com', password: 'Password123@')
# response.data
# response.errors
# response.success?
# response.failure?
# response.user # response.user, response.token
# response.on_success { |user| puts "User created successfully" }.on_failure { |errors| puts "User creation failed" }
#
class ApplicationOperation
  include Responseable

  def self.call(...)
    new.call(...)
  end

  def call
    raise NotImplementedError, "You must define `call` as instance method in #{self.class.name} class"
  end
end
