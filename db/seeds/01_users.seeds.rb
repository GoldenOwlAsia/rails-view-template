puts '===> create users'

puts '---- super admin'
super_admin_email = 'super_admin.gos@rails.boilerplate.com'
if User.find_by(email: super_admin_email).blank?
  super_admin = User.create!(
    email: super_admin_email,
    password: 'Password123!',
    confirmed_at: Time.current
  )

  super_admin.add_role(:super_admin)
else
  puts "#{super_admin_email} already exists, skipped"
end


puts '---- admins'
FactoryBot.create_list(:user, 5, :admin)

puts '---- employees'
FactoryBot.create_list(:user, 100)

puts '---- create users done'
