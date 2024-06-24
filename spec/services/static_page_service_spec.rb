# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StaticPageService, type: :service do
  describe 'static_page_exist?' do
    context 'when static page with static_page_name exists', :create_and_clean_post_files do
      let!(:posts) { [create(:post)] }

      it 'returns true' do
        expect(described_class.static_page_exist?(posts[0].static_page_name)).to be true
      end
    end

    context 'when static page with static_page_name does not exists' do
      it 'returns false' do
        expect(described_class.static_page_exist?('i-dont-exist')).to be false
      end
    end
  end

  describe 'generate_static_page_from_post' do
    context 'when given a post object' do
      let!(:post) { create(:post) }

      around do |example|
        example.run
        described_class.delete_static_page(post.static_page_name)
      end

      it "creates a static page file based on the post's static_page_name" do
        described_class.generate_static_page_from_post(post)
        expect(described_class.static_page_exist?(post.static_page_name)).to be true
      end
    end
  end

  describe 'delete_static_page' do
    let!(:post) { create(:post) }

    before do
      described_class.generate_static_page_from_post(post)
    end

    context 'when static page file exists' do
      it 'deletes file' do
        described_class.delete_static_page(post.static_page_name)
        expect(described_class.static_page_exist?(post.static_page_name)).to be false
      end
    end
  end
end
