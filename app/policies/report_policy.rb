class ReportPolicy < ApplicationPolicy
  def sales_summary?
    elevated?
  end

  def top_products?
    elevated?
  end

  def sales_by_employee?
    elevated?
  end

  private

  def elevated?
    user&.admin? || user&.manager?
  end
end
