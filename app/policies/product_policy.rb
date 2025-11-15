class ProductPolicy
    attr_reader :user, :product
    
    def initialize(user, product)
        @user = user
        @product = product
    end

  def new?
    user && user.admin?
  end
end