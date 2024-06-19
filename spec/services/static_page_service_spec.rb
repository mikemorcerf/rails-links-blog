require 'rails_helper'

RSpec.describe StaticPageService, type: :service do
  describe 'static_page_exist?' do
    context 'when static page with static_page_name exists', :create_and_clean_post_files do
      let!(:posts) { [ create(:post) ] }

      it 'returns true' do
        expect(StaticPageService.static_page_exist?(posts[0].static_page_name)).to be true
      end
    end

    context 'when static page with static_page_name does not exists' do
      it 'returns false' do
        expect(StaticPageService.static_page_exist?('i-dont-exist')).to be false
      end
    end
  end

  describe 'generate_static_page_from_post' do
    context 'when given a post object' do
      let!(:post) { create(:post) }

      around do |example|
        expect(StaticPageService.static_page_exist?(post.static_page_name)).to be false
        example.run
        StaticPageService.delete_static_page(post.static_page_name)
      end

      it "should create a static page file based on the post's static_page_name" do
        StaticPageService.generate_static_page_from_post(post)
        expect(StaticPageService.static_page_exist?(post.static_page_name)).to be true
      end
    end
  end

  describe 'delete_static_page' do
    let!(:post) { create(:post) }

    before do
      StaticPageService.generate_static_page_from_post(post)
      expect(StaticPageService.static_page_exist?(post.static_page_name)).to be true
    end

    context 'when static page file exists' do
      it 'should delete file' do
        StaticPageService.delete_static_page(post.static_page_name)
        expect(StaticPageService.static_page_exist?(post.static_page_name)).to be false
      end
    end
  end
end
