# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:links) }
  it { is_expected.to have_many(:posts) }

  describe 'admin_email?' do
    let!(:user) { build(:user) }

    context 'when user email is the same as in env ADMIN_EMAIL' do
      it 'returns true' do
        expect(user.save).to be(true)
      end
    end

    context 'when user email is not the same as in env ADMIN_EMAIL' do
      it 'raises error' do
        ClimateControl.modify ADMIN_EMAIL: 'wrong_email@wrong.com' do
          expect { user.save }.to raise_error(RuntimeError, "Yu Ain't No Chosen One")
        end
      end
    end
  end
end
