class Storefront::ProductsController < ApplicationController
    def index
        @products = Product.available
                       .filter_by_category(params[:categories])
                       .filter_by_type(params[:types])
                       .filter_by_status(params[:statuses])
                       .search_query(params[:query])

        handle_year_filter
    end

    def show
        @product = Product
               .includes(:images_attachments, :audio_attachment)
               .find(params[:id])

        @related_products = @related_products = Product
            .available
            .related_to(@product)
            .limit(6)
    end
    private

    def handle_year_filter
        return unless params[:year_from].present? || params[:year_to].present?

        unless params[:year_from].to_s.match?(/^\d*$/) && params[:year_to].to_s.match?(/^\d*$/)
        flash.now[:alert] = "Ingrese un año válido (solo números)"
        return
        end

        from = params[:year_from].presence&.to_i
        to   = params[:year_to].presence&.to_i

        if from && to && from > to
        flash.now[:alert] = "El año 'Desde' no puede ser mayor que 'Hasta'"
        return
        end

        @products = @products.filter_by_year_range(from, to)
    end
end
