require_relative './lib/sea_winds_db.rb'
require_relative './lib/reservations.rb'
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

binding.pry

puts "Under construction ..."