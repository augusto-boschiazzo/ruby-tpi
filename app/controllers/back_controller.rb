class BackController < ApplicationController
  before_action :authenticate_user!

  layout "admin"
end
