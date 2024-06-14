class HomeController < ApplicationController
  def index
    @links = user_signed_in? ? Link.all : Link.visible
  end
end
