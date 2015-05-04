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
        items: items
      }
    end

    def co
      {
        id: @ultracart_order.order_id,
        status: 'shipped'
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
  end
end
