# frozen_string_literal: true

class SubscribersController < ApplicationController
  def new
    @subscriber = Subscriber.new
  end

  def create
    @subscriber = Subscriber.new(subscriber_params)

    if @subscriber.save
      post_newsletter = MailingList.find_by(name: 'post_newsletter')
      @subscriber.mailing_lists << post_newsletter

      head :ok
    else
      render :new
    end
  end

  private

  def subscriber_params
    params.require(:subscriber).permit(
      :email
    )
  end
end
