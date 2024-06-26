# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StaticPageService, type: :service do
  describe 'static_page_exist?' do
    context 'when static page with static_page_name exists', :create_and_clean_post_files do
      let!(:posts) { [create(:post)] }

      it 'returns true' do
        expect(described_class.new(posts[0]).static_page_exist?).to be true
      end
    end

    context 'when static page with static_page_name does not exists' do
      let!(:post) { create(:post) }

      it 'returns false' do
        expect(described_class.new(post).static_page_exist?).to be false
      end
    end
  end

  describe 'generate_static_page_from_post' do
    context 'when given a post object' do
      let!(:post) { create(:post) }

      around do |example|
        example.run
        described_class.new(post).delete_static_page
      end

      it "creates a static page file based on the post's static_page_name" do
        described_class.new(post).generate_static_page
        expect(described_class.new(post).static_page_exist?).to be true
      end
    end
  end

  describe 'delete_static_page' do
    let!(:post) { create(:post) }

    before do
      described_class.new(post).generate_static_page
    end

    context 'when static page file exists' do
      it 'deletes file' do
        described_class.new(post).delete_static_page
        expect(described_class.new(post).static_page_exist?).to be false
      end
    end
  end
end
