require 'rails_helper'

RSpec.describe 'Links', type: :request do
  let!(:link1) { create(:link) }
  let!(:link2_invisible) { create(:link, :invisible) }
  let!(:link3) { create(:link) }

  describe 'index' do
    before { get '/links' }

    context 'non-logged-in user' do
      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'displays only visible links in correct order' do
        expect(response.body).not_to include(link2_invisible.title)
        expect(response.body.index(link3.title)).to be < response.body.index(link1.title)
      end

      it 'does not show Link Delete buttons' do
        expect(response.body).not_to include('Delete')
      end
    end

    context 'logged-in user', :authenticated do
      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'displays all links both visible and invisible in correct order' do
        expect(response.body.index(link2_invisible.title)).to be < response.body.index(link1.title)
        expect(response.body.index(link3.title)).to be < response.body.index(link2_invisible.title)
      end

      it 'shows Link Delete buttons' do
        expect(response.body).to include('Delete')
      end
    end
  end

  describe 'show' do
    before { get "/links/#{link1.id}" }

    context 'non-logged-in user' do
      it 'redirects to signin page' do
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context 'logged-in user', :authenticated do
      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'displays links/:id' do
        expect(response.body).to include(link1.title, link1.url, link1.icon, link1.display.to_s, link1.order.to_s)
      end
    end
  end

  describe 'new' do
    before { get '/links/new' }

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
        link: {
          title: Faker::Lorem.sentence,
          url: Faker::Internet.url,
          icon: Faker::Lorem.sentence
        }
      }
    end

    subject { post '/links', params: params }

    context 'non-logged-in user' do
      it 'redirects to signin page' do
        subject
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context 'logged-in user', :authenticated do
      it 'creates new link' do
        expect { subject }.to change(Link, :count).by(1)
      end

      it 'redirects to new link page' do
        subject
        expect(response).to redirect_to(links_url)
        follow_redirect!

        expect(response.body).to include(
          params[:link][:title],
          params[:link][:url],
          params[:link][:icon]
        )
      end
    end
  end

  describe 'edit' do
    before { get "/links/#{link1.id}/edit" }

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

    before { put "/links/#{link1.id}", params: params }

    context 'non-logged-in user' do
      it 'redirects to signin page' do
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context 'logged-in user', :authenticated do
      it 'redirects to updated link page' do
        expect(response).to redirect_to(link_url(link1))
        follow_redirect!

        expect(response.body).to include(
          params[:link][:title],
          params[:link][:url],
          params[:link][:icon]
        )
      end

      it 'updates link' do
        link1.reload
        expect(link1.title).to eq(params[:link][:title])
        expect(link1.url).to eq(params[:link][:url])
        expect(link1.icon).to eq(params[:link][:icon])
      end
    end
  end

  describe 'destroy' do
    subject { delete "/links/#{link1.id}" }

    context 'non-logged-in user' do
      it 'redirects to signin page' do
        subject
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context 'logged-in user', :authenticated do
      it 'deletes link' do
        expect { subject }.to change(Link, :count).by(-1)
      end

      it 'redirects to links index page' do
        subject
        expect(response).to redirect_to(links_url)
        follow_redirect!

        expect(response.body).not_to include(
          link1.title,
          link1.url,
          link1.icon
        )
      end
    end
  end
end
