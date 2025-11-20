class ReportsController < BackController
  def sales_summary
    @sales_by_month = Sale.group_by_month(:sold_at, format: "%b %Y").count
    @amount_by_month = Sale.group_by_month(:sold_at, format: "%b %Y").sum(:total_amount)
  end

  def top_products
    @top_products = ItemSale.joins(:product)
                            .group("products.name")
                            .sum(:quantity)
                            .sort_by { |_name, qty| -qty }
                            .first(10)
  end


  def sales_by_employee
    @sales_by_user = Sale.joins(:user)
                         .group("users.name")
                         .sum(:total_amount)
    @count_by_user = Sale.joins(:user)
                         .group("users.name")
                         .count
  end
end
