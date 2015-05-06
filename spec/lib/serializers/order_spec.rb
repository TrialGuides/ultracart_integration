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
      totals = order[:totals]
      expect(totals[:item]).to eq(ultracart_order.subtotal)
      expect(totals[:adjustment]).to eq(ultracart_order.subtotal_discount)
      expect(totals[:tax]).to eq(ultracart_order.tax)
      expect(totals[:shipping]).to eq(ultracart_order.shipping_handling_total)
      expect(totals[:order]).to eq(ultracart_order.total)
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

    context 'when there are no order adjustments' do
      it 'returns an empty adjustment' do
        expect(order[:adjustments]).to be_empty
      end
    end

    context 'when there are order adjustments' do
      it 'returns the Wombat order adjustment' do
        allow(ultracart_order).to receive(:subtotal_discount).and_return(5.00)
        adjustment = order[:adjustments].first
        expect(adjustment[:name]).to eq('Order Discount')
        expect(adjustment[:value]).to eq(ultracart_order.subtotal_discount * -1)
        expect(order[:totals][:adjustment]).to eq(ultracart_order.subtotal_discount * -1)
      end
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

    context 'without gift certificate' do
      it 'returns the Wombat payments' do
        payment = order[:payments].first
        expect(payment[:status]).to eq('completed')
        expect(payment[:amount]).to eq(ultracart_order.total)
        expect(payment[:payment_method]).to eq(ultracart_order.payment_method)
      end
    end

    context 'with gift certificate' do
      it 'returns a gift certificate payment' do
        allow(ultracart_order).to receive(:gift_certificate_amount).and_return(7.00)
        allow(ultracart_order).to receive(:gift_certificate_code).and_return('QAWS1029')
        payment = order[:payments].last
        expect(payment[:status]).to eq('completed')
        expect(payment[:amount]).to eq(ultracart_order.gift_certificate_amount)
        expect(payment[:code]).to eq(ultracart_order.gift_certificate_code)
        expect(payment[:payment_method]).to eq('Gift Certificate')
      end
    end
  end
end
