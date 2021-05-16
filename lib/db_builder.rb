class SeaWindsDB
  def initialize(database)
    @database = database
    build_tables
  end

  def build_tables  
  # create reservations table
    @database.create_table? :reservations do
      primary_key :id
      Date :date_in
      Date :date_out
      String :made_by
      foreign_key :member_id, :member
    end

    @database.create_table? :member do
      primary_key :id
      String :first_name
      String :last_name
      Date :member_since
      TrueClass :member
    end

    @database.create_table? :hosted_at do
      primary_key :id
      foreign_key :member_id, :member
      foreign_key :occupied_room_id, :occupied_room
    end

    @database.create_table? :occupied_room do
      primary_key :id
      Datetime :check_in
      Datetime :check_out
      foreign_key :room_id, :room
      foreign_key :reservation_id, :reservations
    end

    @database.create_table? :reserved_room do
      primary_key :id
      Integer :number_of_rooms
      foreign_key :room_type_id, :room_type
      foreign_key :reservation_id, :reservations
      String :status
    end

    @database.create_table? :room_type do
      primary_key :id
      String :room_description
      Integer :max_capacity
    end

    @database.create_table? :room do
      primary_key :id
      String :number
      String :room_name
      String :status
      TrueClass :pets
      TrueClass :accessible
      foreign_key :room_type_id, :room_type
      foreign_key :property_id, :property
    end

    @database.create_table? :property do
      primary_key :id
      String :prop_name
      String :description
      foreign_key :owner_contact_id, :member
      Integer :address_id
    end

    @database.create_table? :property_shares do
      primary_key :id
      foreign_key :member_id, :member
      foreign_key :property_id, :property
      Integer :shares
    end

    @database.create_table? :address do
      primary_key :id
      foreign_key :property_id, :property
      String :address_line_1
      String :address_line_2
      String :city
      String :state
      String :postal_code
      String :country
    end
  end

  def room_types
    # create a dataset from the room table
    @database[:room_type]
  end

  def members
    @database[:member]
  end

  def properties
    @database[:property]
  end

  def shares
    @database[:property_shares]
  end

  def rooms
    @database[:room]
  end

  def addresses
    @database[:address]
  end
end