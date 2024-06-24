# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  it { should belong_to(:user) }
  it { should have_and_belong_to_many(:tags) }
  it { should have_rich_text(:body) }

  describe 'create_static_page_name' do
    context 'when saving new post' do
      let!(:post) { build(:post) }

      it 'should generate static_page_name based on title' do
        post.save
        post.reload
        expect(post.static_page_name).to eq(post.title.parameterize)
      end
    end
  end
end
