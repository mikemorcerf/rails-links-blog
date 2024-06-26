# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MailingList do
  it { is_expected.to have_many(:mailing_lists_subscribers) }
  it { is_expected.to have_many(:subscribers).through(:mailing_lists_subscribers) }
end
