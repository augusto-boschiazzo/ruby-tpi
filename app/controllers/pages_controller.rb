class PagesController < ApplicationController
    def home
        @featured_products = Product.includes([ :cover_attachment, :images_attachments ]).limit(10)
    end
end
