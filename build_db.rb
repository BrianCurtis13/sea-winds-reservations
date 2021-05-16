require 'sequel'
require 'csv'
require 'pry'

# connect to an in-memory database
DB = Sequel.sqlite

# create reservations table
DB.create_table :reservations do
  primary_key :id
  Date :date_in
  Date :date_out
  String :made_by
  foreign_key :member_id, :member
end

DB.create_table :member do
  primary_key :id
  String :first_name
  String :last_name
  Date :member_since
  TrueClass :member
end

DB.create_table :hosted_at do
  primary_key :id
  foreign_key :member_id, :member
  foreign_key :occupied_room_id, :occupied_room
end

DB.create_table :occupied_room do
  primary_key :id
  Datetime :check_in
  Datetime :check_out
  foreign_key :room_id, :room
  foreign_key :reservation_id, :reservations
end

DB.create_table :reserved_room do
  primary_key :id
  Integer :number_of_rooms
  foreign_key :room_type_id, :room_type
  foreign_key :reservation_id, :reservations
  String :status
end

DB.create_table :room_type do
  primary_key :id
  String :description
  Integer :max_capacity
end

DB.create_table :room do
  primary_key :id
  String :number
  String :name
  String :status
  TrueClass :pets
  TrueClass :accessible
  foreign_key :room_type_id, :room_type
  foreign_key :property_id, :property
end

DB.create_table :property do
  primary_key :id
  String :name
  String :description
  foreign_key :owner_id, :member
  Integer :address_id
end

DB.create_table :property_shares do
  primary_key :id
  foreign_key :member_id, :member
  foreign_key :property_id, :property
  Integer :shares
end

DB.create_table :address do
  primary_key :id
  foreign_key :property_id, :property
  String :address_line_1
  String :address_line_2
  String :city
  String :state
  String :postal_code
  String :country
end

# create a dataset from the room table
room_types = DB[:room_type]
members = DB[:member]
properties = DB[:property]
shares = DB[:property_shares]
rooms = DB[:room]


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
puts "Room count: #{rooms.count}"

binding.pry; puts ''

