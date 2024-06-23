# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name('newsletter@railsmagicmike.com', 'Rails Magic Mike')
  layout 'mailer'
end
