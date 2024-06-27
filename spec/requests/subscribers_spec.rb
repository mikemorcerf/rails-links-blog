# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Subscribers' do
  describe 'new' do
    before { get '/subscribers/new' }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
  end

  describe 'create' do
    subject(:subscriber_create) { post '/subscribers', params: }

    context 'when providing unique email' do
      let!(:post_mailing_list) { create(:mailing_list, :post_newsletter) }
      let(:params) do
        {
          subscriber: {
            email: Faker::Internet.email
          }
        }
      end

      it 'creates new subscriber' do
        expect { subscriber_create }.to change(Subscriber, :count).by(1)
      end

      it 'creates subscriber subscribed to post_newsletter' do
        subscriber_create
        new_subscriber = Subscriber.find_by(email: params[:subscriber][:email])
        expect(new_subscriber.mailing_lists).to include(post_mailing_list)
      end
    end

    context 'when providing duplicate email using the same casing' do
      let!(:existing_subscriber) { create(:subscriber) }

      let(:params) do
        {
          subscriber: {
            email: existing_subscriber.email
          }
        }
      end

      it 'does not create new subscriber' do
        expect { subscriber_create }.not_to change(Subscriber, :count)
      end
    end

    context 'when providing duplicate email using different casing' do
      let!(:existing_subscriber) { create(:subscriber) }

      let(:params) do
        {
          subscriber: {
            email: existing_subscriber.email.upcase
          }
        }
      end

      it 'does not create new subscriber' do
        expect { subscriber_create }.not_to change(Subscriber, :count)
      end
    end
  end
end
