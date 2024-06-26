# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostsTag do
  it { is_expected.to belong_to(:post) }
  it { is_expected.to belong_to(:tag) }
end
