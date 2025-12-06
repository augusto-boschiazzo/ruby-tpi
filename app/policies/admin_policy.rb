class AdminPolicy < ApplicationPolicy
  def index?
    user.present?
  end
end
