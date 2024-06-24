# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    @links = user_signed_in? ? Link.all : Link.visible
  end

  def show
    @link = Link.find(params[:id])
  end

  def new
    @link = Link.new
  end

  def create
    @link = current_user.links.new(link_params)

    if @link.save
      redirect_to links_url
    else
      render :new
    end
  end

  def edit
    @link = Link.find(params[:id])
  end

  def update
    @link = Link.find(params[:id])

    if @link.update(link_params)
      redirect_to link_url(@link)
    else
      render :edit
    end
  end

  def destroy
    link = Link.find(params[:id])
    link.destroy
    redirect_to links_url
  end

  private

  def link_params
    params.require(:link).permit(
      :display,
      :icon,
      :title,
      :url
    )
  end
end
