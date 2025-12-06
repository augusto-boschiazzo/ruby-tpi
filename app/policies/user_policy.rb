class UserPolicy < ApplicationPolicy
  def index?
    elevated?
  end

  def show?
    elevated?
  end

  def create?
    elevated?
  end

  def new?
    create?
  end

  def update?
    return true if user&.admin?

    user&.manager? && !record&.admin?
  end

  def edit?
    update?
  end

  def destroy?
    user&.admin?
  end

  def assign_role?
    user&.admin?
  end

  private

  def elevated?
    user&.admin? || user&.manager?
  end
end
