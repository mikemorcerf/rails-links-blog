# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LinkType do
  it { is_expected.to have_many(:links) }
end
