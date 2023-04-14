# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
r = Random.new

for i in 0..20
    User.create(email:"user#{i}@test.com",password: "123456",name:"user#{i}",contact: "#{i}233289",dob: "Thu, #{i} Mar 2001 18:23:00.000000000 UTC +00:00",department_id: r.rand(5..8))
    puts "user#{i} created"
end

HR head
{"name"=>"Hr Head Abc", "email"=>"hr@test.com", "dob"=>"1001-01-01", "contact"=>"123456789", "password"=>"[FILTERED]", "password_confirmation"=>"[FILTERED]", "department_id"=>"1", "role"=>"HR Head"}

{"name"=>"Finance Head Abc", "email"=>"fh@test.com", "dob"=>"0110-01-01", "contact"=>"1212121212", "password"=>"[FILTERED]", "password_confirmation"=>"[FILTERED]", "department_id"=>"4", "role"=>"Finance Head"}

{"name"=>"Network Head Abc", "email"=>"nh@test.com", "dob"=>"1110-01-01", "contact"=>"1232654587", "password"=>"[FILTERED]", "password_confirmation"=>"[FILTERED]", "department_id"=>"2", "role"=>"Network Head"}


{"name"=>"Vice HR ", "email"=>"vhr@test.com", "dob"=>"0110-01-01", "contact"=>"21458798", "password"=>"[FILTERED]", "password_confirmation"=>"[FILTERED]", "department_id"=>"1", "role"=>"Vice Hr Head"}


# to create user ticket
# User.last.tickets.create(subject: "abc", description:"def",due_date:"Mon, 25 Mar 2023 13:51:18.299480000 UTC +00:00",priority:"high" ,assigned_to_id:1  , department_id: 6 )


# ap User.find_by_id(20).assigned_tickets.first.messages