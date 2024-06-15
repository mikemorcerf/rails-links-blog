require 'rails_helper'

RSpec.describe 'Home', type: :request do
  subject { get '/' }

  describe 'GET /index' do
    context 'Links' do
      let!(:link3) { create(:link, order: 3) }
      let!(:link1) { create(:link, order: 1) }
      let!(:link2_invisible) { create(:link, :invisible, order: 2) }

      before { subject }

      context 'non-logged-in user' do
        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end

        it 'displays only visible links in correct order' do
          expect(response.body).not_to include(link2_invisible.title)
          expect(response.body.index(link1.title)).to be < response.body.index(link3.title)
        end
      end

      context 'logged-in user', :authenticated do
        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end

        it 'displays all links both visible and invisible in correct order' do
          expect(response.body.index(link1.title)).to be < response.body.index(link2_invisible.title)
          expect(response.body.index(link2_invisible.title)).to be < response.body.index(link3.title)
        end
      end
    end

    context 'Posts' do
      let!(:post1) { create(:post) }
      let!(:post2) { create(:post) }

      before { subject }

      context 'non-logged-in user' do
        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end

        context 'displays all posts' do
          it 'includes post titles' do
            expect(response.body).to include(post1.title, post2.title)
          end

          it 'includes post bodies' do
            expect(response.body).to include(
              post1.body.body.to_plain_text,
              post2.body.body.to_plain_text
            )
          end

          it 'includes post video_urls' do
            expect(response.body).to include(post1.video_url, post2.video_url)
          end
        end
      end

      context 'logged-in user', :authenticated do
        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end

        context 'displays all posts' do
          it 'includes post titles' do
            expect(response.body).to include(post1.title, post2.title)
          end

          it 'includes post bodies' do
            expect(response.body).to include(
              post1.body.body.to_plain_text,
              post2.body.body.to_plain_text
            )
          end

          it 'includes post video_urls' do
            expect(response.body).to include(post1.video_url, post2.video_url)
          end
        end
      end
    end
  end
end
