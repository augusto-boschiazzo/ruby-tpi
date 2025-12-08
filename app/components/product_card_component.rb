# frozen_string_literal: true

class ProductCardComponent < ViewComponent::Base
  attr_reader :product, :classes, :size

  DEFAULT_PLACEHOLDER = "placeholder/product-cover.jpg"
  CARD_SIZE_CLASSES = {
    xs: "min-w-[9rem] max-w-[11rem]",
    sm: "min-w-[11rem] max-w-[14rem]",
    md: "min-w-[14rem] max-w-[16rem]",
    lg: "min-w-[16rem] max-w-[18rem]",
    xl: "min-w-[18rem] max-w-[20rem]"
  }.freeze

  def initialize(product:, size: :md, classes: "")
    @product = product
    @size = normalize_size(size)
    @classes = classes
  end

  def size_classes
    CARD_SIZE_CLASSES.fetch(size, CARD_SIZE_CLASSES[:md])
  end

  private

  def normalize_size(size)
    return :md if size.blank?
    value = size.to_sym
    CARD_SIZE_CLASSES.key?(value) ? value : :md
  rescue StandardError
    :md
  end

  def condition_label
    return "Nuevo" if product.recent?
    return "Usado" if product.used?
    product.status.to_s.humanize
  end

  def condition_classes
    if product.respond_to?(:recent?) && product.recent?
      "bg-emerald-500/90 text-white"
    else
      "bg-amber-500/90 text-white"
    end
  end

  def condition_style
    product.recent? ? "bg-emerald-500/90 text-white" : "bg-amber-500/90 text-white"
  end

  def format_label
    case product.product_type
    when "vinyl"
      "Vinilo"
    when "cd"
      "CD"
    else
      product.product_type.to_s.humanize.presence || "Producto"
    end
  end

  def format_icon
    "svg/" + (product.vinyl? ? "vinyl.svg" : "cd.svg")
  end

  def cover_image
    return product.cover if product.respond_to?(:cover) && product.cover.attached?
    return product.images.first if product.respond_to?(:images) && product.images.attached?

    DEFAULT_PLACEHOLDER
  end

  def cover_alt
    product.try(:name).presence || "Imagen del producto"
  end

  def price_tag
    return unless product.respond_to?(:price) && product.price.present?
    helpers.number_to_currency(product.price, unit: "$", precision: 0)
  end

  def artist_name
    product.try(:author).presence || "Artista desconocido"
  end

  def album_name
    product.try(:name).presence || "Álbum sin nombre"
  end

  def product_description
    product.try(:description).presence
  end

  def cta_path
    helpers.product_path(product)
  rescue StandardError
    "#"
  end
end
