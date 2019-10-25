User.create!(name:  "管理者",
             email: "email@sample.com",
             password:             "password",
             password_confirmation: "password",
             admin: true,
             employee_number: 1
             )
             
User.create!(name:  "上長A",
             email: "email-a@sample.com",
             password:             "password",
             password_confirmation: "password",
             superior: true,
             employee_number: 2
             )
             
User.create!(name:  "上長B",
             email: "email-b@sample.com",
             password:             "password",
             password_confirmation: "password",
             superior: true,
             employee_number: 3
             )
             

4.times do |n|
    name = Faker::Name.name
    email = "email-#{n+1}@sample.com"
    password = "password"
    User.create!(name: name,
                 email: email,
                 password:              password,
                 password_confirmation: password,
                 employee_number: "#{3 + (n+1)}")
end









