# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_link, only: %i[show edit update destroy]

  def index
    @links = user_signed_in? ? Link.all : Link.visible
  end

  def show; end

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

  def edit; end

  def update
    if @link.update(link_params)
      redirect_to link_url(@link)
    else
      render :edit
    end
  end

  def destroy
    @link.destroy
    redirect_to links_url
  end

  private

  def set_link
    @link ||= Link.find(params[:id])
  end

  def link_params
    params.require(:link).permit(
      :display,
      :icon,
      :title,
      :url
    )
  end
end
