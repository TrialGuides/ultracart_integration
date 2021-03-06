require 'delegate'

module OrderDetails
  def self.parse(ultracart_xml)
    order = UltraCartXMLParser.parse(ultracart_xml)
    partner_code = order.channel_partner_code || 'UltraCart'
    order_class_name = [self.name, partner_code + 'Order'].join('::')
    Kernel.const_get(order_class_name).new(order)
  end

  class UltraCartOrder < SimpleDelegator
    def channel
      'UltraCart'
    end

    def order_adjustment
      subtotal_discount > 0.00 ? subtotal_discount * -1 : 0.00
    end
  end

  class ASCOrder < SimpleDelegator
    def order_id
      channel_partner_order_id
    end

    def channel
      'Amazon.com'
    end

    def payment_method
      'Amazon'
    end

    def order_adjustment
      subtotal_discount > 0.00 ? subtotal_discount * -1 : 0.00
    end
  end
end
