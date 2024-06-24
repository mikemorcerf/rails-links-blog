# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Home', type: :request do
  subject(:home_index) { get '/' }

  describe 'index' do
    context 'when showing Links' do
      let!(:first_link) { create(:link) }
      let!(:invisible_link) { create(:link, :invisible) }
      let!(:third_link) { create(:link) }

      before { home_index }

      context 'with non-logged-in user' do
        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end

        it 'does not display invisible_link' do
          expect(response.body).not_to include(invisible_link.title)
        end

        it 'displays third_link before first_link' do
          expect(response.body.index(third_link.title)).to be < response.body.index(first_link.title)
        end
      end

      context 'with logged-in user', :authenticated do
        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end

        it 'displays invisible_link before first_link' do
          expect(response.body.index(invisible_link.title)).to be < response.body.index(first_link.title)
        end

        it 'displays third_link before invisible_link' do
          expect(response.body.index(third_link.title)).to be < response.body.index(invisible_link.title)
        end
      end
    end

    context 'when showing Posts' do
      let!(:posts) { create_list(:post, 3) }

      before { home_index }

      context 'with non-logged-in user' do
        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end

        include_examples 'displays all posts'
      end

      context 'with logged-in user', :authenticated do
        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end

        include_examples 'displays all posts'
      end
    end
  end
end
