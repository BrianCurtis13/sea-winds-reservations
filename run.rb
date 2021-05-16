require_relative './lib/db_builder.rb'
require 'sequel'
require 'csv'
require 'pry'

DB = Sequel.sqlite
swdb = SeaWindsDB.new(DB)

room_types = swdb.room_types
members = swdb.members
properties = swdb.properties
shares = swdb.shares
rooms = swdb.rooms


# populate the tables
room_types.insert(id: 1, description: 'Single', max_capacity: 1)
room_types.insert(id: 2, description: 'Double', max_capacity: 2)
room_types.insert(id: 3, description: 'Twins', max_capacity: 2)
room_types.insert(id: 4, description: 'Double/Single', max_capacity: 3)
room_types.insert(id: 5, description: 'Bunks etc.', max_capacity: 4)

# Initialize spreadsheet input
member_input = CSV.read('./files/swtdb_import - members.csv', headers: true)
properties_input = CSV.read('./files/swtdb_import - properties.csv', headers: true)
property_shares_input = CSV.read('./files/swtdb_import - property_shares.csv', headers: true)

address_input = CSV.read('./files/swtdb_import - addresses.csv', headers: true)
rooms_input = CSV.read('./files/swtdb_import - rooms.csv', headers: true)

# Insert data from spreadsheets

puts "Loading members ..."
member_input.each do |line|
  members.insert(first_name: line["first_name"], last_name: line["last_name"], member_since: line["member_since"], member: line["member"])
end

puts "Loading properties ..."
properties_input.each do |line|
  properties.insert(line.to_h)
end

puts "Loading property shares ..."
property_shares_input.each do |line|
  shares.insert(line.to_h)
end

puts "Loading rooms ..."
rooms_input.each do |line|
  rooms.insert(line.to_h)
end

# print out the number of records
puts "Property count: #{properties.count}"
puts "Room count: #{rooms.count}"

binding.pry; puts ''

