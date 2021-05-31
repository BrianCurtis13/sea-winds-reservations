

def create_reservation(database, date_in, date_out, made_by, member_id)
  database[:reservations].insert(
    [:date_in, :date_out, :made_by, :member_id],
    [date_in, date_out, made_by, member_id]
  )
end

def reserve_room(database, room_id, reservation_id, status = 'active')
  database[:reserved_room].insert(
    [:room_id, :reservation_id, :status],
    [room_id, reservation_id, status]
  )
end

def cancel_room(database, room_id, reservation_id)
  reserved_room = database[:reserved_room].where(room_id: room_id, reservation_id: reservation_id)
  reserved_room.update(status: 'cancelled')
end