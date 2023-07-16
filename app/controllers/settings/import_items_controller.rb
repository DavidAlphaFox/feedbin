module Settings
  class ImportItemsController < ApplicationController
    def update
      @import_item = current_user.import_items.find(params[:id])
      # @subscription.fix_suggestion_none!
      # @subscriptions = current_user.subscriptions.fix_suggestion_present
      #
      # args = [current_user.id, @subscription.id, params[:discovered_feed][:id].to_i]
      #
      # respond_to do |format|
      #   format.html do
      #     replaced = FeedReplacer.new.perform(*args)
      #     redirect_to edit_settings_subscription_url(replaced), notice: "Subscription successfully replaced."
      #   end
      #   format.js do
      #     FeedReplacer.perform_async(*args)
      #   end
      # end
    end
  end
end
