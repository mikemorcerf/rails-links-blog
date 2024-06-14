module AuthenticationHelper
  def self.included(base)
    base.around(:each, :authenticated) do |example|
      @user = User.first || create(:user)
      sign_in @user

      example.run

      sign_out @user
      @user.destroy
    end
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelper, type: :request
end
