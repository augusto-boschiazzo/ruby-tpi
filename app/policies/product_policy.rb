class ProductPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    index?
  end

  def create?
    index?
  end

  def new?
    create?
  end

  def update?
    create?
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end
end
