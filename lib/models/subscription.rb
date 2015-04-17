module WombatObjects
  class Subscription < Base
    def co
      @ultracart_order.mailing_list? ? { id: @ultracart_order.order_id, email: @ultracart_order.email, list_id: ENV['EMAIL_LIST'] } : nil
    end
  end

  @@wombat_objects << Subscription
end
