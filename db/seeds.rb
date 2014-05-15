# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Added default roles
puts 'SETTING UP DEFAULT ROLES'
[{id: 1, name: 'admin', flg_default: 0},
 {id: 2, name: 'trusted', flg_default: 0},
 {id: 3, name: 'user', flg_default: 0},
 {id: 4, name: 'read_only', flg_default: 1}
].each do |role|
  Role.create(role)
end


puts 'SETTING UP DEFAULT Administrator User'
admin = User.new(email: 'admin@localhost.com', first_name: 'Pratik', last_name: 'User',
                 gender: 'other or decline to state',
                 password: 'administrator', password_confirmation: 'administrator')
admin.skip_confirmation!
admin.save!

puts 'SETTING UP DEFAULT Administrator User role'
admin.add_role 'admin'

