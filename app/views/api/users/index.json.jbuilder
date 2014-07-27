json.array!(@users) do |user|
  json.extract! user, :id, :name
  json.url api_user_url(user, format: :json)
end
