require 'delegate'

class OrderDetails
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
  end

  class ASCOrder < SimpleDelegator
    def order_id
      channel_partner_order_id
    end

    def channel
      'Amazon.com'
    end
  end
end
