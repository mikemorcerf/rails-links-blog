# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Link, type: :model do
  let!(:first_link) { create(:link) }
  let!(:second_link) { create(:link) }
  let!(:third_link) { create(:link) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:link_type).optional }

  describe 'reorder_links_after_create' do
    context 'when creating a new Link' do
      it 'sets new link order to 1' do
        expect(third_link.order).to eq(1)
      end

      it 'increases sencond_link order by 1' do
        second_link.reload
        expect(second_link.order).to eq(2)
      end

      it 'increases first_link order by 1' do
        first_link.reload
        expect(first_link.order).to eq(3)
      end
    end
  end

  describe 'reorder_links_after_destroy' do
    context 'when deleting a Link' do
      it 'decreases second_link order by 1' do
        third_link.destroy

        second_link.reload
        expect(second_link.order).to eq(1)
      end

      it 'decreases first_link order by 1' do
        third_link.destroy

        first_link.reload
        expect(first_link.order).to eq(2)
      end
    end
  end
end
