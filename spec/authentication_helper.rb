# frozen_string_literal: true

module AuthenticationHelper
  def self.included(base)
    base.around(:each, :authenticated) do |example|
      @user = User.first || create(:user)
      ClimateControl.modify ADMIN_EMAIL: @user.email do
        sign_in @user
        example.run
      end
    ensure
      sign_out @user
      @user.destroy
    end
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelper, type: :request
end
