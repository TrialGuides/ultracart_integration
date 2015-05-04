require 'spec_helper'

describe WombatObjects::Order do
  # Accounts Receivable
  context 'AR' do
    let(:ultracart_order) { OrderDetails.parse(xml_fixture('ar')) }
    let(:order) { WombatObjects::Order.new(ultracart_order).ar }

    it 'returns the base Wombat fields' do
      expect(order[:id]).to eq(ultracart_order.order_id)
      expect(order[:status]).to eq('complete')
      expect(order[:channel]).to eq('UltraCart')
      expect(Time.parse(order[:placed_on])).to eq(ultracart_order.order_date)
      expect(order[:email]).to eq(ultracart_order.email)
      expect(order[:currency]).to eq('USD')
    end

    it 'returns the Wombat totals' do
      expect(order[:totals][:item]).to eq(ultracart_order.subtotal)
      expect(order[:totals][:tax]).to eq(ultracart_order.tax)
      expect(order[:totals][:shipping]).to eq(ultracart_order.shipping_handling_total)
      expect(order[:totals][:order]).to eq(ultracart_order.total)
    end

    it 'returns the Wombat line items' do
      line_item = order[:line_items].first
      adjustment = line_item[:adjustments].first
      ultracart_item = ultracart_order.items.first
      expect(line_item[:product_id]).to eq(ultracart_item.manufacturer_sku)
      expect(line_item[:name]).to eq(ultracart_item.description)
      expect(line_item[:quantity]).to eq(ultracart_item.quantity)
      expect(line_item[:price]).to eq(ultracart_item.cost)
      expect(adjustment[:name]).to eq('Line Item Discount')
      expect(adjustment[:value]).to eq(-5.00)
      expect(adjustment[:promotion]).to eq(true)
    end

    it 'returns the Wombat shipping address' do
      address = order[:shipping_address]
      ultracart_address = ultracart_order.ship_to_address
      expect(address[:firstname]).to eq(ultracart_address.first_name)
      expect(address[:lastname]).to eq(ultracart_address.last_name)
      expect(address[:address1]).to eq(ultracart_address.address1)
      expect(address[:address2]).to eq(ultracart_address.address2)
      expect(address[:zipcode]).to eq(ultracart_address.zip)
      expect(address[:city]).to eq(ultracart_address.city)
      expect(address[:state]).to eq(ultracart_address.state)
      expect(address[:country]).to eq(ultracart_address.country_code)
      expect(address[:phone]).to eq(ultracart_order.day_phone)
    end

    it 'returns the Wombat billing address' do
      address = order[:billing_address]
      ultracart_address = ultracart_order.bill_to_address
      expect(address[:firstname]).to eq(ultracart_address.first_name)
      expect(address[:lastname]).to eq(ultracart_address.last_name)
      expect(address[:address1]).to eq(ultracart_address.address1)
      expect(address[:address2]).to eq(ultracart_address.address2)
      expect(address[:zipcode]).to eq(ultracart_address.zip)
      expect(address[:city]).to eq(ultracart_address.city)
      expect(address[:state]).to eq(ultracart_address.state)
      expect(address[:country]).to eq(ultracart_address.country_code)
      expect(address[:phone]).to eq(ultracart_order.day_phone)
    end

    it 'returns the Wombat order adjustment' do
      # TODO
    end
  end

  # Rejected
  context 'REJ' do
    let(:ultracart_order) { UltraCartXMLParser.parse(xml_fixture('rej')) }
    let(:order) { WombatObjects::Order.new(ultracart_order).rej }

    it 'returns the base Wombat field' do
      expect(order[:id]).to eq(ultracart_order.order_id)
      expect(order[:status]).to eq('canceled')
    end
  end
  
  # Shipping Department
  context 'SD' do
    let(:ultracart_order) { UltraCartXMLParser.parse(xml_fixture('sd')) }
    let(:order) { WombatObjects::Order.new(ultracart_order).sd }

    it 'returns the base Wombat field' do
      expect(order[:id]).to eq(ultracart_order.order_id)
    end

    it 'returns the Wombat payments' do
      payment = order[:payments].first
      expect(payment[:status]).to eq('completed')
      expect(payment[:amount]).to eq(ultracart_order.total)
      expect(payment[:payment_method]).to eq(ultracart_order.payment_method)
    end
  end
end
