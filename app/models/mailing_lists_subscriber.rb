# frozen_string_literal: true

class MailingListsSubscriber < ApplicationRecord
  belongs_to :mailing_list
  belongs_to :subscriber
end
