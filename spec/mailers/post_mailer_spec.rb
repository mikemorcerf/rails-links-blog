require "rails_helper"

RSpec.describe PostMailer, type: :mailer do
  describe 'new_post' do
    context 'when given a post and subscriber' do
      let!(:post) { create(:post) }
      let!(:subscriber) { create(:subscriber) }
      let!(:mailing_list) { create(:mailing_list, :post_newsletter) }

      before do
        subscriber.mailing_lists << mailing_list
      end

      it 'should generate both html and txt templates' do
        email = PostMailer.with(post: post, subscriber: subscriber).new_post

        assert_emails 1 do
          email.deliver_now
        end

        assert_equal [subscriber.email], email.to

        expect(email.text_part.body.to_s).to include(
          post.title,
          post.video_url,
          post.body.body.to_plain_text,
          post.user.first_name,
          post.user.last_name
        )

        expect(email.html_part.body.to_s).to include(
          post.title,
          post.video_url,
          post.body.body.to_plain_text,
          post.user.first_name,
          post.user.last_name
        )
      end
    end
  end
end
