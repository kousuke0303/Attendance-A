User.create!(name: "Sample User",
             email: "sample@email.com",
             admin: true,
             department: "管理者",
             password: "password",
             password_confirmation: "password")

60.times do |n|
  name  = Faker::Name.name
  email = "sample-#{n+1}@email.com"
  password = "password"
  department = "技術部"
  User.create!(name: name,
               email: email,
               department: department,
               password: password,
               password_confirmation: password)
end