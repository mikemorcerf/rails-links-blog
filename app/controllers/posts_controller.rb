# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @posts = Post.all
  end

  def show
    view_path = "/posts/static_pages/#{params[:static_page_name]}"

    if view_file_exist?(view_path)
      render view_path
    else
      redirect_to posts_url
    end
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find_by(static_page_name: params[:static_page_name])
  end

  def create
    post = current_user.posts.new(post_params)

    if post.save
      StaticPageService.new(post).generate_static_page
      deliver_post_newsletter(post)
      redirect_to post_url(post)
    else
      render :new
    end
  end

  def update
    @post = Post.find_by(static_page_name: params[:static_page_name])
    old_static_page = StaticPageService.new(@post)

    if @post&.update(post_params)
      old_static_page.delete_static_page
      StaticPageService.new(@post).generate_static_page
      redirect_to post_url(@post)
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find_by(static_page_name: params[:static_page_name])
    StaticPageService.new(@post).delete_static_page
    @post.destroy
    redirect_to posts_url
  end

  private

  def post_params
    params.require(:post).permit(
      :title,
      :body,
      :video_url,
      :deliver_newsletter
    )
  end

  def deliver_post_newsletter(post)
    return unless post.deliver_newsletter

    MailingList.post_newsletter_subscribers.find_each do |subscriber|
      PostMailer.with(post:, subscriber:).new_post.deliver_later
    end
  end

  def view_file_exist?(view_path)
    Rails.root.join("app/views#{view_path}.html.erb").exist?
  end
end
