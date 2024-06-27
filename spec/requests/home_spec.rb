# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Home' do
  subject(:home_index) { get '/' }

  describe 'index' do
    # rubocop:disable RSpec/LetSetup
    context 'when showing Links' do
      let!(:first_link) { create(:link) }
      let!(:invisible_link) { create(:link, :invisible) }
      let!(:third_link) { create(:link) }

      before { home_index }

      include_examples 'links_index'
    end
    # rubocop:enable RSpec/LetSetup

    # rubocop:disable RSpec/LetSetup
    context 'when showing Posts' do
      let!(:posts) { create_list(:post, 2) }

      before { home_index }

      include_examples 'posts_index'
    end
    # rubocop:enable RSpec/LetSetup

    context 'when showing Subscription form' do
      before { home_index }

      it 'shows newsletter subscription form' do
        expect(response).to render_template(partial: 'subscribers/_form')
      end
    end
  end
end
