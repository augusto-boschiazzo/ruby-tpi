class Back::AdminController < BackController

    def index
      authorize :user
    end

end