# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

ProductCategory.create([
  {name: 'Pop'},
  {name: 'Jazz'},
  {name: 'Hip hop'},
  {name: 'Techno'},
  {name: 'Funk'}
])

regg = ProductCategory.create(name: 'Reggae')
clasic = ProductCategory.create(name: 'Clásica')
rock = ProductCategory.create(name: 'Rock')

Product.create([
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
])