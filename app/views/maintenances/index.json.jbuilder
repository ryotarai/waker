json.array!(@maintenances) do |maintenance|
  json.extract! maintenance, :id, :topic_id, :start_time, :end_time
  json.url maintenance_url(maintenance, format: :json)
end
