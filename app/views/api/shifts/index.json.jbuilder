json.array!(@shifts) do |shift|
  json.extract! shift, :id, :name, :ical
  json.url api_shift_url(shift, format: :json)
end
