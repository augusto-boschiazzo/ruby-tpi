class Back::ReportsController < BackController
  before_action :authorize_report_access
  def sales_summary
    @sales_by_month = Sale.active.group_by_month(:sold_at, format: "%b %Y").count
    @amount_by_month = Sale.active.group_by_month(:sold_at, format: "%b %Y").sum(:total_amount)
  end

  def top_products
    @top_products = ItemSale.joins(:product, :sale)
                            .merge(Sale.active)
                            .group("products.name")
                            .sum(:quantity)
                            .sort_by { |_name, qty| -qty }
                            .first(10)
  end

  def sales_by_employee
    @sales_by_user = Sale.active.joins(:user)
                     .group("users.id", "users.name")
                     .sum(:total_amount)

    @count_by_user = Sale.active.joins(:user)
                     .group("users.id", "users.name")
                     .count
  end

  private

  def authorize_report_access
    authorize :report, "#{action_name}?".to_sym
  end
end
