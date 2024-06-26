# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tag do
  it { is_expected.to have_many(:posts_tags) }
  it { is_expected.to have_many(:posts).through(:posts_tags) }
end
