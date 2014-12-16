class WelcomeController < ApplicationController

  def index
    @wines = Wine.all
  end

end


