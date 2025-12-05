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
regg   = ProductCategory.find_or_create_by!(name: "Reggae")
clasic = ProductCategory.find_or_create_by!(name: "Clásica")
rock   = ProductCategory.find_or_create_by!(name: "Rock")

# PRODUCTOS
products = [
  # --- REGGAE (Bob Marley / Peter Tosh) ---
  {
    name: "Survival",
    description: "Disco clásico de Bob Marley",
    author: "Bob Marley",
    price: 20,
    stock: 2,
    product_type: "cd",
    product_category: regg,
    status: "used"
  },
  {
    name: "Exodus",
    description: "Otro histórico de Bob Marley",
    author: "Bob Marley",
    price: 25,
    stock: 6,
    year: 1977,
    product_type: "vinyl",
    product_category: regg,
    status: "recent"
  },
  {
    name: "Legalize It",
    description: "Clásico de Peter Tosh",
    author: "Peter Tosh",
    price: 22,
    year: 1976,
    product_type: "vinyl",
    product_category: regg,
    status: "used"
  },

  # --- ROCK (Rolling Stones / Queen / Pink Floyd) ---
  {
    name: "Sticky Fingers",
    description: "Uno de los mejores de los Rolling Stones",
    author: "The Rolling Stones",
    price: 35,
    stock: 5,
    year: 1971,
    product_type: "vinyl",
    product_category: rock,
    status: "recent"
  },
  {
    name: "Let It Bleed",
    description: "Clásico de los Stones",
    author: "The Rolling Stones",
    price: 30,
    year: 1969,
    product_type: "vinyl",
    product_category: rock,
    status: "used"
  },
  {
    name: "A Night at the Opera",
    description: "Disco icónico de Queen",
    author: "Queen",
    price: 40,
    stock: 7,
    year: 1975,
    product_type: "vinyl",
    product_category: rock,
    status: "recent"
  },
  {
    name: "The Wall",
    description: "Obra cumbre de Pink Floyd",
    author: "Pink Floyd",
    price: 45,
    stock: 3,
    year: 1979,
    product_type: "vinyl",
    product_category: rock,
    status: "recent"
  },

  # --- CLÁSICA (Pavarotti) ---
  {
    name: "Pavarotti Greatest Hits",
    description: "Grandes éxitos de Luciano Pavarotti",
    author: "Pavarotti",
    price: 12,
    stock: 8,
    year: 1990,
    product_type: "cd",
    product_category: clasic,
    status: "recent"
  },

  # --- JAZZ / POP ---
  {
    name: "Kind of Blue",
    description: "Álbum histórico de Miles Davis",
    author: "Miles Davis",
    price: 28,
    year: 1959,
    product_type: "vinyl",
    product_category: ProductCategory.find_by(name: "Jazz"),
    status: "used"
  },
  {
    name: "Thriller",
    description: "El disco más vendido de todos los tiempos",
    author: "Michael Jackson",
    price: 50,
    stock: 10,
    year: 1982,
    product_type: "vinyl",
    product_category: ProductCategory.find_by(name: "Pop"),
    status: "recent"
  }
]

products.each do |attrs|
  Product.find_or_create_by!(name: attrs[:name]) do |product|
    product.description      = attrs[:description]
    product.author           = attrs[:author]
    product.price            = attrs[:price]
    product.stock            = attrs[:stock]
    product.year             = attrs[:year]
    product.product_type     = attrs[:product_type]
    product.product_category = attrs[:product_category]
    product.status           = attrs[:status]
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

audio_samples = {
  "Survival"           => "survival.mp3",
  "Pavarotti"          => "jazz.mp3",
  "The Rolling Stones" => "rock.mp3"
}

audio_samples.each do |product_name, file_name|
  product = Product.find_by(name: product_name)

  next unless product
  next if product.audio.attached?

  audio_path = Rails.root.join("db/seed/audio/#{file_name}")

  if File.exist?(audio_path)
    product.audio.attach(
      io: File.open(audio_path),
      filename: file_name,
      content_type: "audio/mpeg"
    )
  else
    puts "No se encontró: #{audio_path}"
  end
end
