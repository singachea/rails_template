u = User.new(:email => "admin_email", :password => "admin_password")
u.role = "admin"
u.activated = true
u.locked = false
u.save!

puts "you have created an admin user [admin_email] with password [admin_password]"