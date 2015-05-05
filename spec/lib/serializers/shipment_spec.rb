require 'spec_helper'

describe WombatObjects::Shipment do
  # Accounts Receivable
  context 'AR' do
    let(:ultracart_order) { OrderDetails.parse(xml_fixture('ar')) }
    let(:shipment) { WombatObjects::Shipment.new(ultracart_order).ar }

    it 'returns the base Wombat fields' do
      expect(shipment[:id]).to eq(ultracart_order.order_id)
      expect(shipment[:order_id]).to eq(ultracart_order.order_id)
      expect(shipment[:email]).to eq(ultracart_order.email)
      expect(shipment[:cost]).to eq(ultracart_order.shipping_handling_total)
      expect(shipment[:status]).to eq('ready')
      expect(shipment[:shipping_method]).to eq(ultracart_order.shipping_method)
    end

    it 'returns the Wombat address fields' do
      address = shipment[:shipping_address]
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

    it 'returns the Wombat item fields' do
      line_item = shipment[:items].first
      ultracart_item = ultracart_order.items.first
      expect(line_item[:product_id]).to eq(ultracart_item.manufacturer_sku)
      expect(line_item[:name]).to eq(ultracart_item.description)
      expect(line_item[:quantity]).to eq(ultracart_item.quantity)
    end

    context 'when it has a shipping adjustment' do
      it 'has a valid adjustments attibute' do
        allow(ultracart_order).to receive(:shipping_handling_total_discount).and_return(5.00)
        adjustments = shipment[:adjustments].first
        expect(adjustments[:name]).to eq('Shipping Discount')
        expect(adjustments[:value]).to eq(-5.00)
      end
    end

    context 'when it does not have a shipping adjustment' do
      it 'has an empty adjustments attribute' do
        expect(shipment[:adjustments]).to be_empty
      end
    end
  end

  # Complete
  context 'CO' do
    let(:ultracart_order) { OrderDetails.parse(xml_fixture('co')) }
    let(:shipment) { WombatObjects::Shipment.new(ultracart_order).co }

    it 'returns the base Wombat fields' do
      expect(shipment[:id]).to eq(ultracart_order.order_id)
      expect(shipment[:status]).to eq('shipped')
      expect(Time.parse(shipment[:shipped_at])).to eq(ultracart_order.shipping_date_time)
      expect(shipment[:tracking]).to eq(ultracart_order.shipping_tracking_number)
    end
  end

  # Rejected
  context 'REJ' do
    let(:ultracart_order) { OrderDetails.parse(xml_fixture('rej')) }
    let(:shipment) { WombatObjects::Shipment.new(ultracart_order).rej }

    it 'returns the base Wombat fields' do
      expect(shipment[:id]).to eq(ultracart_order.order_id)
      expect(shipment[:status]).to eq('canceled')
    end
  end
end
