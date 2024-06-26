# frozen_string_literal: true

RSpec.shared_examples 'posts_index' do
  shared_examples 'display all posts' do
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'includes post titles' do
      posts.each do |post|
        expect(response.body).to include(post.title)
      end
    end

    it 'includes post bodies' do
      posts.each do |post|
        expect(response.body).to include(post.body.body.to_plain_text)
      end
    end
  end

  context 'with non-logged-in user' do
    include_examples 'display all posts'
  end

  context 'with logged-in user', :authenticated do
    include_examples 'display all posts'
  end
end
