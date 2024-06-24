# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LinkType, type: :model do
  it { should belong_to(:link) }
end
