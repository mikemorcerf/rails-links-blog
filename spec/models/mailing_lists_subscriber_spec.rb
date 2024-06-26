# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MailingListsSubscriber do
  it { is_expected.to belong_to(:mailing_list) }
  it { is_expected.to belong_to(:subscriber) }
end
