# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:posts_tags) }
  it { is_expected.to have_many(:tags).through(:posts_tags) }
  it { is_expected.to have_rich_text(:body) }

  describe 'create_static_page_name' do
    context 'when saving new post' do
      let!(:post) { build(:post) }

      it 'generates static_page_name based on title' do
        post.save
        post.reload
        expect(post.static_page_name).to eq(post.title.parameterize)
      end
    end
  end
end
