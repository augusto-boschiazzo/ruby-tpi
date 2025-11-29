module Storefront::ProductsHelper

  
  def active_filter?(key, value)
    Array(params[key]).map(&:to_s).include?(value.to_s)
  end

  
  def toggle_filter(key, value)
    current = Array(params[key]).map(&:to_s)

    if current.include?(value.to_s)
      new_values = current - [value.to_s]
    else      
      new_values = current + [value.to_s]
    end

    request.query_parameters.merge(key => new_values.presence)
  end
end
