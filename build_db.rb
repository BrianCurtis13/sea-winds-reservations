require 'sequel'
require 'pry'

# connect to an in-memory database
DB = Sequel.sqlite

# create reservations table
DB.create_table :reservations do
  primary_key :id
  Date :date_in
  Date :date_out
  String :made_by
  foreign_key :guest_id, :guest
end

DB.create_table :guest do
  primary_key :id
  String :first_name
  String :last_name
  Date :member_since
end

DB.create_table :hosted_at do
  primary_key :id
  foreign_key :guest_id, :guest
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
  foreign_key :room_type_id, :room_type
end

# create a dataset from the room table
rooms = DB[:room]
room_types = DB[:room_type]
guests = DB[:guest]

# populate the tables
room_types.insert(id: 1, description: 'Single', max_capacity: 1)
room_types.insert(id: 2, description: 'Double', max_capacity: 2)
room_types.insert(id: 3, description: 'Twins', max_capacity: 2)
room_types.insert(id: 4, description: 'Double/Single', max_capacity: 3)

rooms.insert(name: '3/4 Bedroom', number: '1', status: 'Available', pets: false, room_type_id: 1)
rooms.insert(name: 'Front Bedroom 1', number: '2', status: 'Available', pets: false, room_type_id: 2)
rooms.insert(name: 'Front Bedroom 2', number: '3', status: 'Unavailable', pets: false, room_type_id: 2)
rooms.insert(name: 'Front Ell Bedroom', number: '4', status: 'Available', pets: false, room_type_id: 3)
rooms.insert(name: 'Back Ell Bedroom', number: '5', status: 'Available', pets: false, room_type_id: 2)
rooms.insert(name: 'Third Floor King', number: '6', status: 'Available', pets: false, room_type_id: 2)
rooms.insert(name: 'Doris O\'Neal Room', number: '7', status: 'Available', pets: false, room_type_id: 1)
rooms.insert(name: 'Third Floor Twins', number: '8', status: 'Available', pets: false, room_type_id: 3)
rooms.insert(name: 'Cabin', number: '9', status: 'Available', pets: true, room_type_id: 4)
rooms.insert(name: 'Barn 1', number: '10', status: 'Unavailable', pets: true, room_type_id: 3)
rooms.insert(name: 'Barn 2', number: '11', status: 'Unavailable', pets: true, room_type_id: 1)
rooms.insert(name: 'Barn 3', number: '12', status: 'Unavailable', pets: true, room_type_id: 2)

guests.insert(first_name: 'Myron', last_name: 'Curtis', member_since: '1939-01-01')
guests.insert(first_name: 'Brian', last_name: 'Curtis', member_since: '1979-10-13')
guests.insert(first_name: 'Marion', last_name: 'Swall', member_since: '1979-05-22')









# print out the number of records
puts "Room count: #{rooms.count}"

binding.pry; puts ''

