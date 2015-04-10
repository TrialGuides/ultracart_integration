class Order < WombatObject
  def initialize(ultracart_order)
    super
  end

  def ar
    {
      id:               @ultracart_order.order_id,
      status:           'complete',
      channel:          'UltraCart',
      placed_on:        placed_on,
      email:            @ultracart_order.email,
##      channel_order_id: '',  # Custom field
      shipping_method:  @ultracart_order.shipping_method,  # Custom field
      currency:         'USD',
      totals:           totals,
      line_items:       line_items,
##      adjustments:      adjustments,
      shipping_address: shipping_address,
      billing_address:  billing_address
    }
  end

  def sd
    {
      id:       @ultracart_order.order_id,
      payments: payments
    }
  end

  def rej
    {
      id:     @ultracart_order.order_id,
      status: 'cancelled'
    }
  end

  def placed_on
    @ultracart_order.order_date.utc.iso8601
  end

  def totals
    {
      item:       @ultracart_order.subtotal,
##      adjustment: '',
      tax:        @ultracart_order.tax,
      shipping:   @ultracart_order.shipping_handling_total,
      order:      @ultracart_order.total
    }
  end

  def line_items
    @ultracart_order.items.collect do |item|
      {
        product_id: item.item_id,
        name:       item.description,
        quantity:   item.quantity,
        price:      item.cost
      }
    end
  end

  def adjustments
  end

  def shipping_address
    address(@ultracart_order.ship_to_address)
  end

  def billing_address
    address(@ultracart_order.bill_to_address)
  end

  def payments
    {
      status:         'completed',
      amount:         @ultracart_order.total,
      payment_method: @ultracart_order.payment_method
    }
  end

  private

  def phone
    @ultracart_order.day_phone || @ultracart_order.evening_phone
  end

  def address(ultracart_address)
    {
      firstname: ultracart_address.first_name,
      lastname:  ultracart_address.last_name,
      address1:  ultracart_address.address1,
      address2:  ultracart_address.address2,
      zipcode:   ultracart_address.zip,
      city:      ultracart_address.city,
      state:     ultracart_address.state,
      country:   ultracart_address.country_code,
      phone:     phone
    }
  end
end
