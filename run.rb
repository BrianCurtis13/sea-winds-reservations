require_relative './lib/db_builder.rb'
require_relative './lib/display_and_output.rb'
require 'sequel'
require 'csv'
require 'pry'

def view_report(view)
  {
    "Property" => view[:prop_name],
    "Room Number" => view[:number],
    "Name" => view[:room_name],
    "Status" => view[:status],
    "Accessible?" => view[:accessible],
    "Allows Pets?" => view[:pets],
    "Bed Type" => view[:room_description],
    "Sleeps" => view[:max_capacity],
    "Owner Contact" => owner_contact(view),
    "Location" => location(view)
  }
end

def owner_contact(line)
  "#{line[:first_name]} #{line[:last_name]}"
end

def location(line)
  "#{line[:city]} #{line[:state]}"
end

DB = Sequel.sqlite('sea_winds.db')
swdb = SeaWindsDB.new(DB)

room_types = swdb.room_types
members = swdb.members
properties = swdb.properties
shares = swdb.shares
rooms = swdb.rooms
addresses = swdb.addresses


# populate the tables
room_types.insert(id: 1, room_description: 'Single', max_capacity: 1)
room_types.insert(id: 2, room_description: 'Double', max_capacity: 2)
room_types.insert(id: 3, room_description: 'Twins', max_capacity: 2)
room_types.insert(id: 4, room_description: 'Double/Single', max_capacity: 3)
room_types.insert(id: 5, room_description: 'Bunks etc.', max_capacity: 4)

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

puts "Loading addresses ..."
address_input.each do |line|
  addresses.insert(line.to_h)
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

view = rooms.join_table(:inner, :room_type, id: :room_type_id)
            .join_table(:inner, :property, id: Sequel[:room][:property_id])
            .join_table(:inner, :member, id: Sequel[:property][:owner_contact_id])
            .join_table(:inner, :address, id: Sequel[:property][:address_id])

view_report_data = view.map {|line| view_report(line)}

binding.pry; puts ''

