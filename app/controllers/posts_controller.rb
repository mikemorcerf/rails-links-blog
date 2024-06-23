# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_post, only: %i[edit update destroy]

  def index
    @posts = Post.all
  end

  def show
    if StaticPageService.static_page_exist?(params[:static_page_name])
      render "/posts/static_pages/#{params[:static_page_name]}"
    else
      redirect_to posts_url
    end
  end

  def new; end

  def create
    post = current_user.posts.new(post_params)

    if post.save
      StaticPageService.generate_static_page_from_post(post)

      if post.deliver_newsletter
        MailingList.post_newsletter_subscribers.find_each do |subscriber|
          PostMailer.with(post:, subscriber:).new_post.deliver_later
        end
      end

      redirect_to post_url(post)
    else
      render :new
    end
  end

  def edit; end

  def update
    old_static_page_name = @post&.static_page_name

    if @post&.update(post_params)
      StaticPageService.delete_static_page(old_static_page_name)
      StaticPageService.generate_static_page_from_post(@post)
      redirect_to post_url(@post)
    else
      render :edit
    end
  end

  def destroy
    StaticPageService.delete_static_page(@post.static_page_name)
    @post.destroy
    redirect_to posts_url
  end

  private

  def set_post
    @post ||= Post.find_by(static_page_name: params[:static_page_name])
  end

  def post_params
    params.require(:post).permit(
      :title,
      :body,
      :video_url,
      :deliver_newsletter
    )
  end
end
