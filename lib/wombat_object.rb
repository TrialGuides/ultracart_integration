require 'set'

module WombatObjects
  @@wombat_objects = Set.new

  def self.object_list
    @@wombat_objects
  end

  def self.serialize(ultracart_order)
    self.object_list.collect { |m| m.serialize(ultracart_order) }.reduce({}, :merge).to_json
  end

  class Base
    def self.serialize(ultracart_order)
      current_stage = ultracart_order.current_stage.downcase
      wombat_object = self.class.name.split('::').last.downcase + 's'
      { wombat_object => [self.new(ultracart_order).send(current_stage)].compact }
    end

    def initialize(ultracart_order)
      @ultracart_order = ultracart_order
    end

    def ar; end  # Accounts Receivable
    def co; end  # Completed Order
    def in; end  # Inserting (Placed order)
    def pc; end  # Pending Clearance (Check orders)
    def po; end  # Pre-Order
    def qr; end  # Quote Request
    def qs; end  # Quote Sent
    def sd; end  # Shipping Department
    def rej; end # Rejected
  end
end
