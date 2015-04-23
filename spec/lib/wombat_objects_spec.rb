require 'spec_helper'

describe WombatObjects do
  let(:ultracart_order) { double("ultracart_order", current_stage: 'PO') }
  let(:wombat_objects) { ObjectSpace.each_object(Class).select { |klass| klass < WombatObjects::Base  }.to_set }
    
  it 'registered all the subclasses of WombatObjects::Base' do
    expect(WombatObjects.object_list).to eq(wombat_objects)
  end

  it 'can serialize an UltraCart order' do
    object_names = wombat_objects.map { |wombat_object| wombat_object.name.split('::').last.downcase + 's' }
    result = object_names.map { |object_name| { object_name => [] } }.reduce({}, :merge)
    expect(JSON.parse(WombatObjects.serialize(ultracart_order))).to eq(result)
  end
end
