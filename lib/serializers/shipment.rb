module WombatObjects
  class Shipment < Base
    include WombatObjects::Address

    def ar
      {
        id: @ultracart_order.order_id,
        order_id: @ultracart_order.order_id,
        email: @ultracart_order.email,
        cost: @ultracart_order.shipping_handling_total,
        status: 'ready',
        shipping_method: @ultracart_order.shipping_method,
        shipping_address: address(@ultracart_order.ship_to_address),
        items: items,
        adjustments: shipping_adjustments
      }
    end

    def co
      {
        id: @ultracart_order.order_id,
        status: 'shipped',
        shipped_at: @ultracart_order.shipping_date_time.utc.iso8601,
        tracking: @ultracart_order.shipping_tracking_number
      }
    end

    def rej
      {
        id: @ultracart_order.order_id,
        status: 'canceled'
      }
    end

    private

    def items
      @ultracart_order.items.map do |item|
        {
          product_id:  item.manufacturer_sku || item.item_id,
          name:        item.description,
          quantity:    item.quantity
        }
      end
    end

    def shipping_adjustments
      shipping_discount = @ultracart_order.shipping_handling_total_discount
      return [] if shipping_discount.nil? || shipping_discount == 0.00

      [{
         name: 'Shipping Discount',
         value: shipping_discount * -1,
       }]
    end
  end
end
