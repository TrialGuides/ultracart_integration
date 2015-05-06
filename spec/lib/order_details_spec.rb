require 'spec_helper'

describe OrderDetails do
  context 'when passed an UltraCart order' do
    let(:order_xml) { xml_fixture('ar') }
    let(:order) { OrderDetails.parse(order_xml) }
 
    it 'returns an instance of UltraCartOrder' do
      expect(order).to be_a OrderDetails::UltraCartOrder
    end
  end
  
  context 'when passed an Amazon.com order' do
    let(:order_xml) { xml_fixture('ar_asc') }
    let(:order) { OrderDetails.parse(order_xml) }

    it 'returns an instance of ASCOrder' do
      expect(order).to be_a OrderDetails::ASCOrder
    end
  end

  describe OrderDetails::UltraCartOrder do
    let(:order_xml) { xml_fixture('ar') }
    let(:ultracart_order) { UltraCartXMLParser.parse(order_xml) }
    let(:order) { OrderDetails.parse(order_xml) }

    it 'returns the default order ID' do
      expect(order.order_id).to eq(ultracart_order.order_id)
    end

    it 'returns a channel of UltraCart' do
      expect(order.channel).to eq('UltraCart')
    end

    it 'returns the payment menthod from the UltraCart XML' do
      expect(order.payment_method).to eq('Credit Card')
    end

    context 'when there is not an order adjustment' do
      it 'should have a 0.00 order adjustment' do
        expect(order.order_adjustment).to eq(0.00)
      end
    end

    context 'when there is an order adjustment' do
      it 'should return the correct order_adjustment' do
        allow(order).to receive(:subtotal_discount).and_return(5.00)
        expect(order.order_adjustment).to eq(-5.00)
      end
    end
  end

  describe OrderDetails::ASCOrder do
    let(:order_xml) { xml_fixture('ar_asc') }
    let(:ultracart_order) { UltraCartXMLParser.parse(order_xml) }
    let(:order) { OrderDetails.parse(order_xml) }

    it 'returns the channel parter order ID' do
      expect(order.order_id).to eq(ultracart_order.channel_partner_order_id)
    end

    it 'returns a channel of Amazon.com' do
      expect(order.channel).to eq('Amazon.com')
    end

    it 'returns the payment menthod of Amazon Payment' do
      expect(order.payment_method).to eq('Amazon')
    end

    context 'when there is not an order adjustment' do
      it 'should have a 0.00 order adjustment' do
        expect(order.order_adjustment).to eq(0.00)
      end
    end

    context 'when there is an order adjustment' do
      it 'should return the correct order_adjustment' do
        allow(order).to receive(:subtotal_discount).and_return(5.00)
        expect(order.order_adjustment).to eq(-5.00)
      end
    end
  end
end
