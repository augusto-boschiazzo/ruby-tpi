# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

[ "Pop", "Jazz", "Hip hop", "Techno", "Funk" ].each do |name|
  ProductCategory.find_or_create_by!(name: name)
end

regg   = ProductCategory.find_or_create_by!(name: 'Reggae')
clasic = ProductCategory.find_or_create_by!(name: 'Clásica')
rock   = ProductCategory.find_or_create_by!(name: 'Rock')

[
  {
    name: "Survival",
    description: "un cd de bob marley",
    author: "bob marley",
    price: 20,
    stock: 3,
    product_type: "cd",
    product_category: regg,
    status: "used"
  },
  {
    name: "Pavarotti",
    description: "un cd de pavarotti",
    author: "Pavarotti",
    price: 10,
    stock: 8,
    product_type: "cd",
    product_category: clasic,
    status: "recent"
  },
  {
    name: "The Rolling Stones",
    description: "un vinilo de los stones",
    author: "The Rolling Stones",
    price: 30,
    stock: 12,
    product_type: "vinyl",
    product_category: rock,
    status: "recent"
  }
].each do |attrs|
  Product.find_or_create_by!(name: attrs[:name]) do |product|
    product.description       = attrs[:description]
    product.author            = attrs[:author]
    product.price             = attrs[:price]
    product.stock             = attrs[:stock]
    product.product_type      = attrs[:product_type]
    product.product_category  = attrs[:product_category]
    product.status            = attrs[:status]
  end
end

[
  { name: "Ana Martínez", dni: "12345678", email: "ana.martinez@example.com" },
  { name: "Carlos Gómez", dni: "23456789", email: "carlos.gomez@example.com" },
  { name: "Lucía Fernández", dni: "34567890", email: "lucia.fernandez@example.com" },
  { name: "Martín Rodríguez", dni: "45678901", email: "martin.rodriguez@example.com" },
  { name: "Sofía López", dni: "56789012", email: "sofia.lopez@example.com" },
  { name: "Julián Torres", dni: "67890123", email: "julian.torres@example.com" },
  { name: "Valentina Ruiz", dni: "78901234", email: "valentina.ruiz@example.com" },
  { name: "Diego Castro", dni: "89012345", email: "diego.castro@example.com" },
  { name: "Camila Herrera", dni: "90123456", email: "camila.herrera@example.com" },
  { name: "Federico Sosa", dni: "01234567", email: "federico.sosa@example.com" }
].each do |attrs|
  Client.find_or_create_by!(dni: attrs[:dni]) do |client|
    client.name  = attrs[:name]
    client.email = attrs[:email]
  end
end

users = [
  {
    name: "Admin",
    last_name: "Principal",
    username: "admin",
    email: "admin@example.com",
    role: :admin,
    password: "password123"
  },
  {
    name: "María",
    last_name: "García",
    username: "manager1",
    email: "manager@example.com",
    role: :manager,
    password: "password123"
  },
  {
    name: "Juan",
    last_name: "Pérez",
    username: "employee1",
    email: "employee@example.com",
    role: :employee,
    password: "password123"
  }
]

users.each do |attrs|
  User.find_or_create_by!(email: attrs[:email]) do |user|
    user.name      = attrs[:name]
    user.last_name = attrs[:last_name]
    user.username  = attrs[:username]
    user.role      = attrs[:role]
    user.password  = attrs[:password]
  end
end
