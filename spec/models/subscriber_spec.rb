# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscriber, type: :model do
  it { is_expected.to have_many(:mailing_lists_subscribers) }
  it { is_expected.to have_many(:mailing_lists).through(:mailing_lists_subscribers) }
end
