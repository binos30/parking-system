json.data do
  json.small_vacant_slots_count @small_vacant_slots_count
  json.medium_vacant_slots_count @medium_vacant_slots_count
  json.large_vacant_slots_count @large_vacant_slots_count

  json.small_reserved_slots_count @small_reserved_slots_count
  json.medium_reserved_slots_count @medium_reserved_slots_count
  json.large_reserved_slots_count @large_reserved_slots_count

  json.small_occupied_slots_count @small_occupied_slots_count
  json.medium_occupied_slots_count @medium_occupied_slots_count
  json.large_occupied_slots_count @large_occupied_slots_count
end
