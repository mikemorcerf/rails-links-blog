# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MailingList, type: :model do
  it { should have_and_belong_to_many(:subscribers) }
end
