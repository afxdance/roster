# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# User.delete_all
# Dancer.delete_all
# Team.delete_all

User.create_with(
  username: "admin",
  password: "password",
  password_confirmation: "password",
  role: "admin",
).find_or_create_by(id: 1)

User.create_with(
  username: "young cai",
  password: "password123",
  password_confirmation: "password123",
  role: "director",
).find_or_create_by(id: 2)
dancer_extra_fields = {
  exp_interest: "not important rn",
  tech_interest: "not important rn",
  camp_interest: "not important rn",
  reach_workshop_interest: "not important rn",
  reach_news_interest: "not important rn",
}
# Dancer.create!(name: "Peter Le",
#                email: "peter@peter.peter",
#                phone: "pet-erp-eter",
#                gender: "peter",
#                year: "1",
#                dance_experience: "peter",
#                **dancer_extra_fields)
# Dancer.create!(name: "Alice Wu",
#                email: "alice@alice.alice",
#                phone: "ali-cea-lice",
#                gender: "alice",
#                year: "1",
#                dance_experience: "alice",
#                **dancer_extra_fields)
# Dancer.create!(name: "Stella Wang",
#                email: "stella@stella.stella",
#                phone: "ste-lla-wang",
#                gender: "stella",
#                year: "2",
#                dance_experience: "stella",
#                **dancer_extra_fields)
Dancer.create_with(
  phone: "pet-erp-eter",
  gender: "peter",
  year: "3",
  dance_experience: "no",
  **dancer_extra_fields,
).find_or_create_by(name: "Evelyn Liu", email: "peter@peter.peter")
Team.create_with(
  level: "Project",
  practice_time: "all the time",
  locked: false,
  maximum_picks: 100,
).find_or_create_by(name: "AFX Help")
Team.create_with(
  level: "Project",
  practice_time: "never",
  locked: false,
  maximum_picks: 50,
).find_or_create_by(name: "AFX Oasis")
# Team.create(name: "AFX Help",
#              level: "Project",
#              practice_time: "all the time",
#              locked: false,
#              maximum_picks: 100)
# Team.create(name: "AFX Oasis",
#              level: "Project",
#              practice_time: "never",
#              locked: false,
#              maximum_picks: 50)

# give admin access to all seeded teams
User.find(1).teams = Team.all

Rails.env.development?
