# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Home', type: :request do
  subject { get '/' }

  describe 'index' do
    context 'Links' do
      let!(:link1) { create(:link) }
      let!(:link2_invisible) { create(:link, :invisible) }
      let!(:link3) { create(:link) }

      before { subject }

      context 'non-logged-in user' do
        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end

        it 'displays only visible links in correct order' do
          expect(response.body).not_to include(link2_invisible.title)
          expect(response.body.index(link3.title)).to be < response.body.index(link1.title)
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
      end
    end

    context 'Posts' do
      let!(:posts) { create_list(:post, 3) }

      before { subject }

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
  end
end
