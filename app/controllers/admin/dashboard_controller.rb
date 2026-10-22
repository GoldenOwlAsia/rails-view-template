module Admin
  class DashboardController < BaseController
    def index
      @presenter = DashboardPresenter.new(year: Date.current.year)
    end
  end
end
