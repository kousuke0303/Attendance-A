User.create!(name: "Sample User",
             email: "sample@email.com",
             admin: true,
             affiliation: "管理者",
             password: "password",
             password_confirmation: "password")
             
User.create!(name: "superior A",
             email: "superior_a@email.com",
             superior: true,
             affiliation: "部長",
             password: "password",
             password_confirmation: "password")
             
User.create!(name: "superior B",
             email: "superior_b@email.com",
             superior: true,
             affiliation: "課長",
             password: "password",
             password_confirmation: "password")

60.times do |n|
  name  = Faker::Name.name
  email = "sample-#{n+1}@email.com"
  password = "password"
  affiliation = "技術部"
  User.create!(name: name,
               email: email,
               affiliation: affiliation,
               password: password,
               password_confirmation: password)
end