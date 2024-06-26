# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Posts' do
  # rubocop:disable RSpec/LetSetup
  describe 'index' do
    let!(:posts) { create_list(:post, 2) }

    before { get '/posts' }

    include_examples 'posts_index'
  end
  # rubocop:enable RSpec/LetSetup

  describe 'show' do
    let!(:posts) { create_list(:post, 2) }

    before { get "/posts/#{posts[1].static_page_name}" }

    context 'with non-logged-in user', :create_and_clean_post_files do
      it 'renders static page for post' do
        expect(response.body).to include(
          posts[1].title,
          posts[1].video_url,
          posts[1].body.body.to_plain_text
        )
      end
    end

    context 'with logged-in user', :authenticated, :create_and_clean_post_files do
      it 'renders static page for post' do
        expect(response.body).to include(
          posts[1].title,
          posts[1].video_url,
          posts[1].body.body.to_plain_text
        )
      end
    end

    context 'when providing a static page name that does not exist' do
      it 'redirects to posts#index' do
        expect(response).to redirect_to(posts_url)
      end
    end
  end

  describe 'new' do
    before { get '/posts/new' }

    context 'with non-logged-in user' do
      it 'redirects to signin page' do
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context 'with logged-in user', :authenticated do
      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'create' do
    subject(:post_create) { post '/posts', params: }

    let(:params) do
      {
        post: {
          title: Faker::Lorem.sentence,
          body: "<p>#{SecureRandom.alphanumeric(8)}</p>",
          video_url: Faker::Internet.url,
          deliver_newsletter: false
        }
      }
    end

    context 'with non-logged-in user' do
      it 'redirects to signin page' do
        post_create
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context 'with logged-in user', :authenticated do
      after { delete_static_page_by_name(params[:post][:title].parameterize) }

      it 'creates new post' do
        expect { post_create }.to change(Post, :count).by(1)
      end

      it 'redirects to new post static page' do
        post_create

        expect(response).to redirect_to(post_url(params[:post][:title].parameterize))
      end

      it 'displays new post information after redirect' do
        post_create
        follow_redirect!

        expect(response.body).to include(params[:post][:title], params[:post][:video_url], params[:post][:body])
      end
    end

    context 'when post deliver_newsletter is true', :authenticated do
      after { delete_static_page_by_name(params[:post][:title].parameterize) }

      let!(:mailing_list) { create(:mailing_list, :post_newsletter) }
      let!(:first_subscriber) { create(:subscriber) }
      let!(:second_subscriber) { create(:subscriber) }
      let(:non_subscriber) { create(:subscriber) }

      before do
        params[:post][:deliver_newsletter] = true
        first_subscriber.mailing_lists << mailing_list
        second_subscriber.mailing_lists << mailing_list
      end

      it 'sends newsletter to all post_newsletter subscribers' do
        assert_emails 2 do
          post_create
          perform_enqueued_jobs
        end
      end
    end

    context 'when using invalid params', :authenticated do
      let(:params) do
        {
          post: {
            title: nil,
            body: "<p>#{SecureRandom.alphanumeric(8)}</p>",
            video_url: Faker::Internet.url,
            deliver_newsletter: false
          }
        }
      end

      it 'renders new form' do
        post_create
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'edit' do
    let!(:posts) { [create(:post)] }

    before { get "/posts/#{posts[0].static_page_name}/edit" }

    context 'with non-logged-in user', :create_and_clean_post_files do
      it 'redirects to signin page' do
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context 'with logged-in user', :authenticated, :create_and_clean_post_files do
      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'update' do
    subject(:post_update) { put "/posts/#{posts[0].static_page_name}", params: }

    let!(:posts) { [create(:post)] }
    let(:params) do
      {
        post: {
          title: Faker::Lorem.sentence,
          body: "<p>#{SecureRandom.alphanumeric(8)}</p>",
          video_url: Faker::Internet.url
        }
      }
    end

    context 'with non-logged-in user' do
      it 'redirects to signin page' do
        post_update
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context 'with logged-in user', :authenticated, :create_and_clean_post_files do
      after { StaticPageService.new(posts[0].reload).delete_static_page }

      it 'deletes old static page file' do
        post_update
        expect(StaticPageService.new(posts[0]).static_page_exist?).not_to be true
      end

      it 'creates new static page file' do
        post_update
        expect(StaticPageService.new(posts[0].reload).static_page_exist?).to be true
      end

      it 'redirects to updated post static page' do
        post_update
        expect(response).to redirect_to(post_url(params[:post][:title].parameterize))
      end

      it 'displays new post information after redirect' do
        post_update
        follow_redirect!

        expect(response.body).to include(params[:post][:title], params[:post][:video_url], params[:post][:body])
      end

      it 'updates post title' do
        post_update
        posts[0].reload
        expect(posts[0].title).to eq(params[:post][:title])
      end

      it 'updates post video_url' do
        post_update
        posts[0].reload
        expect(posts[0].video_url).to eq(params[:post][:video_url])
      end

      it 'updates post body' do
        post_update
        posts[0].reload
        expect(posts[0].body.body.to_s).to include(params[:post][:body])
      end
    end

    context 'when using invalid params', :authenticated do
      let(:params) do
        {
          post: {
            title: nil,
            body: "<p>#{SecureRandom.alphanumeric(8)}</p>",
            video_url: Faker::Internet.url,
            deliver_newsletter: false
          }
        }
      end

      it 'renders new form' do
        post_update
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'destroy' do
    subject(:post_destroy) { delete "/posts/#{posts[0].static_page_name}" }

    let!(:posts) { [create(:post)] }

    context 'with non-logged-in user' do
      it 'redirects to signin page' do
        post_destroy
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context 'with logged-in user', :authenticated, :create_and_clean_post_files do
      it 'deletes static page file name' do
        post_destroy
        expect(StaticPageService.new(posts[0]).static_page_exist?).not_to be true
      end

      it 'redirects index page' do
        post_destroy
        expect(response).to redirect_to(posts_url)
      end

      it 'deletes post' do
        expect { post_destroy }.to change(Post, :count).by(-1)
      end
    end
  end
end
