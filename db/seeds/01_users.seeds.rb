puts '~> Creating admins'
FactoryBot.create_list(:user, 5, :admin)
puts '~> Created admins'

puts '~> Creating employees'
FactoryBot.create_list(:user, 30)
puts '~> Created employees'
