class Product < ApplicationRecord
  acts_as_paranoid

  belongs_to :product_category

  # Para item_sales
  has_many :item_sales
  has_many :sales, through: :item_sales

  has_one_attached :audio
  has_one_attached :cover
  has_many_attached :images

  enum :status, [ :recent, :used ]
  enum :product_type, [ :vinyl, :cd ]

  scope :available, -> { 
    includes(:cover_attachment, :images_attachments)
    .where(deleted_at: nil)
    .order(created_at: :desc)
  }

  scope :filter_by_category, ->(category_ids) {
    where(product_category_id: category_ids) if category_ids.present?
  }

  scope :filter_by_type, ->(types) {
    where(product_type: types) if types.present?
  }

  scope :filter_by_status, ->(statuses) {
    where(status: statuses) if statuses.present?
  }
  
  scope :search_query, ->(query) {
    return all if query.blank?

    words = query.downcase.split
    scope = all
    words.each do |word|
      scope = scope.where("LOWER(name) LIKE :q OR LOWER(author) LIKE :q", q: "%#{word}%")
    end
    scope
  }

  scope :filter_by_year_range, ->(from, to) {
    if from.present? && to.present?
      where(year: from..to)
    elsif from.present?
      where("year >= ?", from)
    elsif to.present?
      where("year <= ?", to)
    else
      all
    end
  }

  scope :related_to, ->(product) {
  where.not(id: product.id)
    .where(
      "product_category_id = :cat OR product_type = :type OR author = :author",
      cat: product.product_category_id,
      type: product.product_type,
      author: product.author
    )
  }

  validates :name, presence: true, uniqueness: true
  validates :stock,
            numericality: { greater_than_or_equal_to: 0 },
            presence: true,
            if: -> { recent? }

  validates :stock, inclusion: { in: [ 0, 1 ] }, if: -> { used? }

  validate :audio_only_for_used
  validate :audio_must_be_an_audio_file

  before_validation :normalize_stock
  before_destroy :reset_stock

  after_save :purge_audio_if_requested

  attr_accessor :remove_audio


  private

  def normalize_stock
    # Si es 'used', el stock debe ser nil, no "" ni "0"
    self.stock = 1 if used?
  end

  def audio_only_for_used
    return if remove_audio == "1"

    if recent? && audio.attached?
      errors.add(:audio, "solo se puede adjuntar si el producto es usado")
    end
  end

  def audio_must_be_an_audio_file
    return if recent?
    return unless audio.attached?

    unless audio.content_type.start_with?("audio")
      errors.add(:audio, "debe ser un archivo de audio (mp3, wav, ogg, etc.)")
      audio.purge
    end
  end

  def reset_stock
    update_column(:stock, 0) # usa update_column para evitar validaciones
  end

  def purge_audio_if_requested
    audio.purge if remove_audio == "1"
  end
end
