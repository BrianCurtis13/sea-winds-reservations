# Builds a new Sea Winds database from csv source files.

require_relative './lib/sea_winds_db.rb'
require_relative './lib/reservations.rb'
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

db_filepath = './files/sea_winds.db'

if File.exist? db_filepath
  puts "Sea Winds database found at #{db_filepath}. Delete and retry if you want to rebuild from csv files."
  abort
end

DB = Sequel.sqlite('./files/sea_winds.db')
swdb = SeaWindsDB.new(DB)

room_types = swdb.room_types
members = swdb.members
properties = swdb.properties
shares = swdb.shares
rooms = swdb.rooms
addresses = swdb.addresses
reserved_rooms = swdb.reserved_rooms

# populate the tables

# Initialize spreadsheet input
room_types_input = CSV.read('./files/room_types.csv', headers: true)

member_input = CSV.read('./files/swtdb_import - members.csv', headers: true)
properties_input = CSV.read('./files/swtdb_import - properties.csv', headers: true)
property_shares_input = CSV.read('./files/swtdb_import - property_shares.csv', headers: true)

address_input = CSV.read('./files/swtdb_import - addresses.csv', headers: true)
rooms_input = CSV.read('./files/swtdb_import - rooms.csv', headers: true)

# Insert data from spreadsheets

puts "Loading room types ..."
room_types_input.each do |line|
  room_types.insert(line.to_h)
end

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

db = swdb.database

view = rooms.join_table(:inner, :room_type, id: :room_type_id)
            .join_table(:inner, :property, id: Sequel[:room][:property_id])
            .join_table(:inner, :member, id: Sequel[:property][:owner_contact_id])
            .join_table(:inner, :address, id: Sequel[:property][:address_id])

swdb.database.create_view(:rooms_report, view)

reservations_view = reserved_rooms.join_table(:inner, :reservations, id: :reservation_id)
                                  .join_table(:inner, :member, id: :member_id)
                                  .join_table(:inner, :room, id: Sequel[:reserved_room][:room_id])
                                  .join_table(:inner, :property, id: Sequel[:room][:property_id])

swdb.database.create_view(:reservations_report, reservations_view)

view_report_data = view.map {|line| view_report(line)}

# binding.pry; puts ''

puts "Finished building Sea Winds database!"
puts "Done!"
