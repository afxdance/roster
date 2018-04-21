# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
<<<<<<< HEAD
User.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?
=======
User.create!(email: "admin@example.com", password: "password", password_confirmation: "password") if Rails.env.development?
>>>>>>> 80f3068defb317f7fb3f9be30c045b56243b1c1b
