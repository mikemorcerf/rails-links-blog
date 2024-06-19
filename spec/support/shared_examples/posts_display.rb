RSpec.shared_examples 'displays all posts' do
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
