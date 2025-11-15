json.extract! sale, :id, :sold_at, :total_amount, :client_id, :user_id, :created_at, :updated_at
json.url sale_url(sale, format: :json)
