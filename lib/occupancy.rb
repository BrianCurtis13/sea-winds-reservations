def occupy_room(database, check_in_time, room_id, reservation_id)
  database[:occupied_room].insert(
    [:check_in, :room_id, :reservation_id],
    [check_in_time, room_id, reservation_id]
  )
end

def host_occupant(database, member_id, occupied_room_id)
  database[:hosted_at].insert(
    [:member_id, :occupied_room_id],
    [member_id, occupied_room_id]
  )
end
