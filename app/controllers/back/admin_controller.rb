class Back::AdminController < BackController

    def index
      authorize :admin
    end

end