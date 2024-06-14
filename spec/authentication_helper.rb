module AuthenticationHelper
  def self.included(base)
    base.around(:each, :authenticated) do |example|
      user_email = Faker::Internet.email
      ENV['ADMIN_EMAIL'] = user_email
      @user = create(:user, email: user_email)
      sign_in @user

      example.run

      sign_out @user
      ENV['ADMIN_EMAIL'] = nil
    end
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelper, type: :request
end
