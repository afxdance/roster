# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

User.create!(email: "admin@example.com", password: "password", password_confirmation: "password") if Rails.env.development?

# csv_text = File.read(Rails.root.join('lib', 'seeds', 'dancers-edited2.csv'))
# puts csv_text
csv_text = File.read(Rails.root.join('lib', 'seeds', 'dancers-edited2.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  d = Dancer.new
  d.name = row['name']
  d.email = row['email']
  d.phone = row['phone']
  d.gender = row['gender']
  d.year = row['year']
  d.experience = row['experience']
  d.save
  # puts "#{d.name} saved"
end

puts "There are now #{Dancer.count} rows in the Dancers table"
