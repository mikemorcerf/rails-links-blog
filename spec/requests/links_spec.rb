# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Links' do
  let!(:first_link) { create(:link) }

  # rubocop:disable RSpec/LetSetup
  describe 'index' do
    let!(:invisible_link) { create(:link, :invisible) }
    let!(:third_link) { create(:link) }

    before { get '/links' }

    include_examples 'links_index'
  end
  # rubocop:enable RSpec/LetSetup

  describe 'show' do
    before { get "/links/#{first_link.id}" }

    context 'with non-logged-in user' do
      it 'redirects to signin page' do
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context 'with logged-in user', :authenticated do
      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'displays links title' do
        expect(response.body).to include(first_link.title)
      end

      it 'displays links url' do
        expect(response.body).to include(first_link.url)
      end

      it 'displays link icon' do
        expect(response.body).to include(first_link.icon)
      end

      it 'displays link display' do
        expect(response.body).to include(first_link.display.to_s)
      end

      it 'displays link order' do
        expect(response.body).to include(first_link.order.to_s)
      end
    end
  end

  describe 'new' do
    before { get '/links/new' }

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
    subject(:link_create) { post '/links', params: }

    let(:params) do
      {
        link: {
          title: Faker::Lorem.sentence,
          url: Faker::Internet.url,
          icon: Faker::Lorem.sentence
        }
      }
    end

    context 'with non-logged-in user' do
      it 'redirects to signin page' do
        link_create
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context 'with logged-in user', :authenticated do
      it 'creates new link' do
        expect { link_create }.to change(Link, :count).by(1)
      end

      it 'redirects to new link page' do
        link_create
        expect(response).to redirect_to(links_url)
      end

      it 'displays new link information after redirect' do
        link_create
        follow_redirect!

        expect(response.body).to include(params[:link][:title], params[:link][:url], params[:link][:icon])
      end
    end

    context 'when using invalid params', :authenticated do
      let(:params) do
        {
          link: {
            display: nil
          }
        }
      end

      it 'renders new form' do
        link_create
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'edit' do
    before { get "/links/#{first_link.id}/edit" }

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

  describe 'update' do
    let(:params) do
      {
        link: {
          title: Faker::Lorem.sentence,
          url: Faker::Internet.url,
          icon: Faker::Lorem.sentence
        }
      }
    end

    before { put "/links/#{first_link.id}", params: }

    context 'with non-logged-in user' do
      it 'redirects to signin page' do
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context 'with logged-in user', :authenticated do
      it 'redirects to updated link page' do
        expect(response).to redirect_to(link_url(first_link))
      end

      it 'displays new link information after redirect' do
        follow_redirect!

        expect(response.body).to include(params[:link][:title], params[:link][:url], params[:link][:icon])
      end

      it 'updates link title' do
        first_link.reload
        expect(first_link.title).to eq(params[:link][:title])
      end

      it 'updates link url' do
        first_link.reload
        expect(first_link.url).to eq(params[:link][:url])
      end

      it 'updates link icon' do
        first_link.reload
        expect(first_link.icon).to eq(params[:link][:icon])
      end
    end

    context 'when using invalid params', :authenticated do
      let(:params) do
        {
          link: {
            display: nil
          }
        }
      end

      it 'renders edit form' do
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'destroy' do
    subject(:link_destroy) { delete "/links/#{first_link.id}" }

    context 'with non-logged-in user' do
      it 'redirects to signin page' do
        link_destroy
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context 'with logged-in user', :authenticated do
      it 'deletes link' do
        expect { link_destroy }.to change(Link, :count).by(-1)
      end

      it 'redirects to links index page' do
        link_destroy
        expect(response).to redirect_to(links_url)
      end

      it 'index no longer displays link information after redirect' do
        link_destroy
        follow_redirect!

        expect(response.body).not_to include(first_link.title, first_link.url, first_link.icon)
      end
    end
  end
end
