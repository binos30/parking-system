json.extract! parking_lot, :id, :name
json.parking_slots_attributes parking_lot.parking_slots do |parking_slot|
  json.id parking_slot.id
  json.code parking_slot.code
  json.slot_type parking_slot.slot_type
  json.distances parking_slot.distances
end
json.url api_v1_parking_lot_url(parking_lot, format: :json)
