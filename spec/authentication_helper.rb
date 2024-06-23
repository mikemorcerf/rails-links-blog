module AuthenticationHelper
  def self.included(base)
    base.around(:each, :authenticated) do |example|
      begin
        set_admin_email_env

        @user = User.first || create(:user)
        sign_in @user
        example.run
      ensure
        sign_out @user
        @user.destroy
      end
    end
  end

  def set_admin_email_env
    ENV['ADMIN_EMAIL'] ||= User.first.present? ?
      User.first.email :
      "#{SecureRandom.alphanumeric(10)}@#{SecureRandom.alphanumeric(5)}.com".downcase
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelper, type: :request
end
