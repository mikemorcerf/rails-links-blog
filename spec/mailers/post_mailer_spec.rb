# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostMailer do
  describe 'new_post' do
    context 'when given a post and subscriber' do
      let!(:post) { create(:post) }
      let!(:subscriber) { create(:subscriber) }
      let!(:mailing_list) { create(:mailing_list, :post_newsletter) }
      let(:email) { described_class.with(post:, subscriber:).new_post }

      before do
        subscriber.mailing_lists << mailing_list
      end

      it 'delivers email' do
        assert_emails 1 do
          email.deliver_now
        end
      end

      it 'sends to subscriber' do
        expect(email.to).to eq([subscriber.email])
      end

      it 'generates html template with email title' do
        expect(email.html_part.body.to_s).to include(post.title)
      end

      it 'generates html template with email video_url' do
        expect(email.html_part.body.to_s).to include(post.video_url)
      end

      it 'generates html template with email body' do
        expect(email.html_part.body.to_s).to include(post.body.body.to_plain_text)
      end

      it 'generates html template with email first_name' do
        expect(email.html_part.body.to_s).to include(post.user.first_name)
      end

      it 'generates html template with email last_name' do
        expect(email.html_part.body.to_s).to include(post.user.last_name)
      end

      it 'generates txt template with email title' do
        expect(email.text_part.body.to_s).to include(post.title)
      end

      it 'generates txt template with email video_url' do
        expect(email.text_part.body.to_s).to include(post.video_url)
      end

      it 'generates txt template with email body' do
        expect(email.text_part.body.to_s).to include(post.body.body.to_plain_text)
      end

      it 'generates txt template with email first_name' do
        expect(email.text_part.body.to_s).to include(post.user.first_name)
      end

      it 'generates txt template with email last_name' do
        expect(email.text_part.body.to_s).to include(post.user.last_name)
      end
    end
  end
end
