class Client < ApplicationRecord
  has_many :sales, dependent: :nullify

  validates :name, presence: true
  validates :dni,
            presence: true,
            numericality: { only_integer: true,
                            message: I18n.t("activerecord.errors.models.client.attributes.dni.not_a_number") },
            uniqueness: { message: I18n.t("activerecord.errors.models.client.attributes.dni.taken") }
  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP,
                      message: I18n.t("activerecord.errors.models.client.attributes.email.invalid") },
            allow_blank: true
end
