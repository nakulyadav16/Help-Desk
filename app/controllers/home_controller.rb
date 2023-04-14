class HomeController < ApplicationController
  before_action :authenticate_user! , only: [ :show]

  def index
    respond_to do |format|
      format.js {render layout: false}
      format.html {render 'index'}
    end
  end

end
