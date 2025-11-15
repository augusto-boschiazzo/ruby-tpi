class Client < ApplicationRecord
  # Otra cosa que se me olvido de pasar cuando se me corrompio el archivo
  has_many :sales

  validates :name, :dni, presence: true
  # Mensages personalizados para las validaciones
  validates :dni,
            numericality: { only_integer: true, message: "El DNI debe ser solo numérico" },
            uniqueness: { message: "Este DNI ya está registrado" }
  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "El formato del email no es válido" },
            allow_blank: true
end
