# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @links = user_signed_in? ? Link.all : Link.visible
    # TODO: add pagination and truncate
    @posts = Post.all
    @subscriber = Subscriber.new
  end
end
