class Storefront::ProductsController < ApplicationController
    def index
        @products = Product.includes(:cover_attachment, :images_attachments)
                       .where(deleted_at: nil)
                       .order(created_at: :desc)

        @products = @products.where(product_category_id: params[:categories]) if params[:categories].present?
        @products = @products.where(product_type: params[:types]) if params[:types].present?
        @products = @products.where(status: params[:statuses]) if params[:statuses].present?
        if params[:query].present?
            params[:query].downcase.split.each do |word|
                @products = @products.where(
                    "LOWER(name) LIKE :q OR LOWER(author) LIKE :q",
                q: "%#{word}%"
            )
            end
        end

        if params[:year_from].present? || params[:year_to].present?

            error_message = nil

        unless params[:year_from].to_s.match?(/^\d*$/) && params[:year_to].to_s.match?(/^\d*$/)
            error_message = "Ingrese un año válido (solo números)"
        else
            from = params[:year_from].to_i if params[:year_from].present?
            to   = params[:year_to].to_i   if params[:year_to].present?

            if from && to
            if from <= to
                @products = @products.where(year: from..to)
            else
                error_message = "El año 'Desde' no puede ser mayor que 'Hasta'"
            end
            elsif from
            @products = @products.where("year >= ?", from)
            elsif to
            @products = @products.where("year <= ?", to)
            end
        end

            flash.now[:alert] = error_message if error_message.present?

        end
    end
    def show
        @product = Product
               .includes(:images_attachments, :audio_attachment)
               .find(params[:id])

        @related_products = Product
            .includes(:cover_attachment, :images_attachments)
            .where.not(id: @product.id)
            .where(deleted_at: nil)
            .where(
            "product_category_id = :cat OR product_type = :type OR author = :author",
            cat: @product.product_category_id,
            type: @product.product_type,
            author: @product.author
            )
            .limit(6)
    end
end
