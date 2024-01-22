json.extract! booking,
              :id,
              :parking_slot_id,
              :vehicle_type,
              :plate_number,
              :date_park,
              :date_unpark,
              :fee
json.slot_code booking.parking_slot.code
json.url api_v1_booking_url(booking, format: :json)
