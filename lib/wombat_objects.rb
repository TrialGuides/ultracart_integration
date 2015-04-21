require 'set'

module WombatObjects
  @@wombat_objects = Set.new

  def self.object_list
    @@wombat_objects
  end

  def self.serialize(ultracart_order)
    self.object_list.collect { |m| m.new(ultracart_order).serialize }.reduce({}, :merge).to_json
  end

  class Base
    def initialize(ultracart_order)
      @ultracart_order = ultracart_order
    end

    def wombat_object
      self.class.name.split('::').last.downcase + 's'
    end

    def serialize
      { wombat_object => [ send(@ultracart_order.current_stage.downcase) ].compact }
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
