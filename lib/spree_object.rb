class SpreeObject
  def self.subclasses
    ObjectSpace.each_object(Class).select { |klass| klass < self }
  end

  def self.data(ultracart_order)
    self.subclasses.collect { |m| m.new(ultracart_order).to_h }.reduce({}, :merge)
  end

  def initialize(ultracart_order)
    @ultracart_order = ultracart_order
  end

  def to_h
    { self.class.to_s.downcase + 's' => [ send(@ultracart_order.current_stage.downcase) ].compact }
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
