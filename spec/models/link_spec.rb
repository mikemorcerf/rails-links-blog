# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Link, type: :model do
  let!(:link1) { create(:link) }
  let!(:link2) { create(:link) }
  let!(:link3) { create(:link) }

  describe 'reorder_links_after_create' do
    context 'when creating a new Link' do
      it 'Link.order shoud become 1 and older Link orders are increased by 1' do
        expect(link3.order).to eq(1)
        link2.reload
        expect(link2.order).to eq(2)
        link1.reload
        expect(link1.order).to eq(3)
      end
    end
  end

  describe 'reorder_links_after_destroy' do
    context 'when deleting a Link' do
      it "Links that have order greater than deleted link's order should have their order decreased by 1" do
        link3.destroy

        link2.reload
        expect(link2.order).to eq(1)
        link1.reload
        expect(link1.order).to eq(2)
      end
    end
  end
end
