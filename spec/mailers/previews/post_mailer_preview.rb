# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/post
class PostMailerPreview < ActionMailer::Preview
  def new_post
    # TODO
    PostMailer.with(post: Post.first).new_post
  end
end
