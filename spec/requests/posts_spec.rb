require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  describe 'index' do
    let!(:posts) { create_list(:post, 3) }

    before { get '/posts' }

    context 'non-logged-in user' do
      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      include_examples 'displays all posts'
    end

    context 'logged-in user', :authenticated do
      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      include_examples 'displays all posts'
    end
  end

  describe 'show' do
    let!(:posts) { create_list(:post, 3) }

    before { get "/posts/#{posts[1].static_page_name}" }

    context 'non-logged-in user', :create_and_clean_post_files do
      it 'renders static page for post' do
        expect(response.body).to include(
          posts[1].title,
          posts[1].video_url,
          posts[1].body.body.to_plain_text
        )
      end
    end

    context 'logged-in user', :authenticated, :create_and_clean_post_files do
      it 'renders static page for post' do
        expect(response.body).to include(
          posts[1].title,
          posts[1].video_url,
          posts[1].body.body.to_plain_text
        )
      end
    end
  end

  describe 'new' do
    before { get '/posts/new' }

    context 'non-logged-in user' do
      it 'redirects to signin page' do
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context 'logged-in user', :authenticated do
      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'create' do
    let(:params) do
      {
        post: {
          title: Faker::Lorem.sentence,
          body: "<p>#{SecureRandom.alphanumeric(8)}</p>",
          video_url: Faker::Internet.url
        }
      }
    end

    subject { post '/posts', params: params }

    context 'non-logged-in user' do
      it 'redirects to signin page' do
        subject
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context 'logged-in user', :authenticated do
      after { StaticPageService.delete_static_page(params[:post][:title].parameterize) }

      it 'creates new post' do
        expect { subject }.to change(Post, :count).by(1)
      end

      it 'redirects to new post static page' do
        subject

        expect(response).to redirect_to(post_url(params[:post][:title].parameterize))
        follow_redirect!

        expect(response.body).to include(
          params[:post][:title],
          params[:post][:video_url],
          params[:post][:body]
        )
      end
    end
  end

  describe 'edit' do
    let!(:posts) { [ create(:post) ] }

    before { get "/posts/#{posts[0].static_page_name}/edit" }

    context 'non-logged-in user', :create_and_clean_post_files do
      it 'redirects to signin page' do
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context 'logged-in user', :authenticated, :create_and_clean_post_files do
      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'update' do
    let!(:posts) { [ create(:post) ] }
    let(:params) do
      {
        post: {
          title: Faker::Lorem.sentence,
          body: "<p>#{SecureRandom.alphanumeric(8)}</p>",
          video_url: Faker::Internet.url
        }
      }
    end

    subject { put "/posts/#{posts[0].static_page_name}", params: params }

    context 'non-logged-in user' do
      it 'redirects to signin page' do
        subject
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context 'logged-in user', :authenticated, :create_and_clean_post_files do
      after { StaticPageService.delete_static_page(params[:post][:title].parameterize) }

      it 'updates static page file name' do
        expect(StaticPageService.static_page_exist?(posts[0].static_page_name)).to be true
        subject
        expect(StaticPageService.static_page_exist?(posts[0].static_page_name)).not_to be true
        expect(StaticPageService.static_page_exist?(params[:post][:title].parameterize)).to be true
      end

      it 'redirects to updated post static page' do
        subject
        expect(response).to redirect_to(post_url(params[:post][:title].parameterize))
        follow_redirect!

        expect(response.body).to include(
          params[:post][:title],
          params[:post][:video_url],
          params[:post][:body]
        )
      end

      it 'updates post' do
        subject
        posts[0].reload
        expect(posts[0].title).to eq(params[:post][:title])
        expect(posts[0].video_url).to eq(params[:post][:video_url])
        expect(posts[0].body.body.to_s).to include(params[:post][:body])
      end
    end
  end

  describe 'destroy' do
    let!(:posts) { [ create(:post) ] }

    subject { delete "/posts/#{posts[0].static_page_name}" }

    context 'non-logged-in user' do
      it 'redirects to signin page' do
        subject
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context 'logged-in user', :authenticated, :create_and_clean_post_files do
      it 'deletes static page file name' do
        expect(StaticPageService.static_page_exist?(posts[0].static_page_name)).to be true
        subject
        expect(StaticPageService.static_page_exist?(posts[0].static_page_name)).not_to be true
      end

      it 'redirects index page' do
        subject
        expect(response).to redirect_to(posts_url)
      end

      it 'deletes post' do
        expect { subject }.to change(Post, :count).by(-1)
      end
    end
  end
end
