json.extract! follow_request, :id, :recipient, :references, :sender, :references, :status, :created_at, :updated_at
json.url follow_request_url(follow_request, format: :json)
