# frozen_string_literal: true

require "securerandom"

class CarouselComponent < ViewComponent::Base
  attr_reader :autoplay, :interval, :loop, :pause_on_hover, :show_arrows, :aria_label

  DEFAULT_IMAGES = [
    {
      src: "carousel/image1.jpeg",
      alt: "Vinilos expuestos en una pared",
      description: "Descubrí las ediciones exclusivas de esta temporada"
    },
    {
      src: "carousel/image2.jpeg",
      alt: "Detalle de una bandeja tocadiscos",
      description: "Envíos a todo el país con embalaje premium"
    },
    {
      src: "carousel/image3.jpeg",
      alt: "Colección de CDs apilados",
      description: "Nuevos ingresos cada semana, suscribite a las novedades"
    }
  ].freeze

  def initialize(images: nil, autoplay: false, interval: 5_000, loop: true, pause_on_hover: true, show_arrows: true, aria_label: "Galería de imágenes del sitio")
    @raw_images = images.presence || DEFAULT_IMAGES
    @autoplay = autoplay
    @interval = interval
    @loop = loop
    @pause_on_hover = pause_on_hover
    @show_arrows = show_arrows
    @aria_label = aria_label
  end

  def slides
    @slides ||= Array(@raw_images).each_with_index.filter_map do |image, index|
      normalize_image(image, index)
    end
  end

  def multiple_slides?
    slides.size > 1
  end

  def show_arrows?
    show_arrows && multiple_slides?
  end

  def dom_id
    @dom_id ||= "svc-#{SecureRandom.hex(4)}"
  end

  private

  def normalize_image(image, index)
    return if image.blank?

    if image.is_a?(String)
      build_slide(image, nil, nil, index)
    elsif image.respond_to?(:symbolize_keys)
      build_from_hash(image.symbolize_keys, index)
    elsif image.is_a?(Hash)
      build_from_hash(image.symbolize_keys, index)
    elsif image.respond_to?(:object_name)
      build_slide(image.object_name, image.try(:alt), image.try(:description), index)
    else
      build_slide(image[:src], image[:alt], image[:description], index) if image.respond_to?(:[])
    end
  end

  def build_from_hash(hash, index)
    src = hash[:src] || hash[:url] || hash[:object_name]
    build_slide(src, hash[:alt], hash[:description], index)
  end

  def build_slide(src, alt, description, index)
    return if src.blank?

    {
      src: src,
      alt: alt.presence || default_alt(index),
      description: description.presence
    }
  end

  def default_alt(index)
    "Imagen #{index + 1} del carrusel"
  end
end
