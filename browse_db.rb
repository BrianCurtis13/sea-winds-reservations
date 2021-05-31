require_relative './lib/sea_winds_db.rb'
require_relative './lib/reservations.rb'
require_relative './lib/occupancy.rb'
require_relative './lib/display_and_output.rb'
require 'sequel'
require 'csv'
require 'pry'

DB = Sequel.sqlite('./files/sea_winds.db')
swdb = SeaWindsDB.new(DB)

room_types = swdb.room_types
members = swdb.members
properties = swdb.properties
shares = swdb.shares
rooms = swdb.rooms
addresses = swdb.addresses

db = swdb.database

puts "Who are you?"
user_id = gets.chomp

user = members.where(id: user_id).first

if user == nil
  abort "You are not a member."
else
  @user_id = user[:id]
  @user_name = "#{user[:first_name]} #{user[:last_name]}"
end

puts "Select a property:"
display_onscreen_list(properties,:id,[:prop_name])
until @property != nil
  property_id = gets.chomp
  @property = properties.where(id: property_id).first
  if @property == nil
    puts "That property doesn't exist yet."
    next
  end
end

puts "Adding sample reservations ..."

res_id = create_reservation(swdb.database, '2021-06-28','2021-07-05','Brian',5)
reserve_room(swdb.database,1,res_id)
reserve_room(swdb.database,2,res_id)
reserve_room(swdb.database,4,res_id)
reserve_room(swdb.database,5,res_id)

res_id = create_reservation(swdb.database, '2021-06-28','2021-07-05','Brian',2)
reserve_room(swdb.database,6,res_id)
reserve_room(swdb.database,7,res_id)
reserve_room(swdb.database,8,res_id)

res_id = create_reservation(db,'2021-12-23','2022-01-02','Brian',6)
reserve_room(db,22,res_id)

res_id = create_reservation(db,'2021-12-23','2022-01-02','Brian',4)
reserve_room(db,23,res_id)

puts "Booking you in the Knapp House for right now ..."
start_date = (Date.today - 2)
end_date = (Date.today + 5)
res_id = create_reservation(db,start_date,end_date,'Brian',user_id)
reserve_room(db,16,res_id)
reserve_room(db,17,res_id)
reserve_room(db,18,res_id)

puts "Checking in ..."

check_in_time = (DateTime.now - 2)
occupied_room_id = occupy_room(db,check_in_time,16,res_id)
host_occupant(db, 2, occupied_room_id)
occupied_room_id = occupy_room(db,check_in_time,17,res_id)
host_occupant(db, 1, occupied_room_id)
occupied_room_id = occupy_room(db,check_in_time,18,res_id)
host_occupant(db, 3, occupied_room_id)





binding.pry

puts "Under construction ..."