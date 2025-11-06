json.extract! product, :id, :name, :description, :author, :price, :stock, :product_type, :product_category_id, :status, :created_at, :updated_at
json.url product_url(product, format: :json)
