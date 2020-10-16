module Notifications
  class SendService < BaseService
    def initialize(notification_object)
      @notification_object = notification_object
    end

    def call
      Notifications::Slack::SendService.call(@notification_object) if Rails.configuration.netam.dig(:notification, :slack_webhook).present?
    end
  end
end