# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(email: "admin@afx.dance", password: "password", password_confirmation: "password")

Dancer.create!(name: "Peter Le", email: "peter@peter.peter", phone: "pet-erp-eter", gender: "peter", year: "1", experience: "peter")
Dancer.create!(name: "Alice Wu", email: "alice@alice.alice", phone: "ali-cea-lice", gender: "alice", year: "1", experience: "alice")
Dancer.create!(name: "Stella Wang", email: "stella@stella.stella", phone: "ste-lla-wang", gender: "stella", year: "2", experience: "stella")

Team.create!(name: "AFX Help", type_of: "Project", practice_time: "all the time", locked: false, maximum_picks: 100)

Rails.env.development?
