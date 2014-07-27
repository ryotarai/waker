json.extract! @incident, :id, :description, :details, :status, :created_at, :updated_at
json.provider @incident.provider.as_json(methods: [:details], except: [:details_json])
