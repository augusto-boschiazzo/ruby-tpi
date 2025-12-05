module Storefront::ProductsHelper
  def active_filter?(key, value)
    Array(params[key]).map(&:to_s).include?(value.to_s)
  end


  def toggle_filter(key, value)
    current_params = params.to_unsafe_h.deep_dup

    current_values = Array(current_params[key]).map(&:to_s)

    if current_values.include?(value.to_s)
      new_values = current_values - [ value.to_s ]
    else
      new_values = current_values + [ value.to_s ]
    end

    current_params.merge(key => new_values.presence)
  end
end
