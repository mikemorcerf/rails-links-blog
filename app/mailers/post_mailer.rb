# frozen_string_literal: true

class PostMailer < ApplicationMailer
  include Rails.application.routes.url_helpers

  default from: email_address_with_name('newsletter@railsmagicmike.com', 'Rails Magic Mike Posts')

  def new_post
    @post = params[:post]
    @post_author = @post.user
    subscriber = params[:subscriber]

    mail(to: subscriber.email, subject: @post.title)
  end
end
