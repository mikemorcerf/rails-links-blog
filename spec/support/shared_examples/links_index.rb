# frozen_string_literal: true

RSpec.shared_examples 'links_index' do
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

    it 'does not show Link Delete buttons' do
      expect(response.body).not_to include('Delete')
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

    it 'shows Link Delete buttons' do
      expect(response.body).to include('Delete')
    end
  end
end
