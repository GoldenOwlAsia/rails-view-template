puts '~> Creating admin users'

super_admin_email = 'super_admin@gmail.com'
if User.find_by(email: super_admin_email).blank?
  super_admin = User.create!(
    email: super_admin_email,
    password: 'Password123@',
    confirmed_at: Time.current
  )

  super_admin.add_role(:super_admin)
end

puts '~> Created admin users'
