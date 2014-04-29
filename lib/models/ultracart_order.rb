require 'carmen'
require 'nokogiri'
require 'json'

class UltraCartOrder
  attr_reader :xml, :billing_address, :shipping_address

  def initialize(xml)
    @xml = Nokogiri::XML(xml)
    @order = @xml.xpath('order')
    @billing_address = UltraCartAddress.new(@xml, 'bill')
    @shipping_address = UltraCartAddress.new(@xml, 'ship')
  end

  def order_id
    @order_id ||= @xml.xpath('//order_id').first.text
  end

  def order_date
    @order_date ||= @xml.xpath('//order_date').text.strip
  end

  def current_stage
    @current_stage ||= @xml.xpath('//current_stage').text
  end

  def shipping_method
   @shipping_method ||= @xml.xpath('//shipping_method').text
  end

  def email
    @emil ||= @xml.xpath('//email').text.strip
  end

  def mailing_list?
    @mailing_list ||= to_bool(@xml.xpath('//mailing_list').text)
  end

  def weight
    @weight ||= @xml.xpath('//weight').text.strip
  end

  def weight_value
    @weight_value = weight.split[0].to_f
  end

  def weight_units
    @weight_units = weight.split[1]
  end

  def has_customer_profile?
    @has_customer_profile ||= to_bool(@xml.xpath('//has_customer_profile').text)
  end

  def gift?
    @gift ||= to_bool(@xml.xpath('//gift').text)
  end

  def channel_partner_code
    @channel_partner_code ||= @xml.xpath('//channel_partner_code').text.strip
  end

  def channel_partner_order_id
    @channel_partner_order_id ||= @xml.xpath('//channel_partner_order_id').text.strip
  end

  def special_instructions
    @special_instructions ||= @xml.xpath('//special_instructions').text.strip
  end

  def has_special_instructions?
    ! special_instructions.empty?
  end

  def amazon_order?
    @amazon_order ||= channel_partner_code.downcase == 'asc'
  end

  def usps_order?
    @usps_order ||= shipping_method.downcase.start_with?('usps')
  end

  def fedex_order?
    @fedex_order ||= shipping_method.downcase.start_with?('fedex')
  end

  def day_phone
    @day_phone = @xml.xpath('//day_phone').text.strip
  end

  def evening_phone
    @evening_phone = @xml.xpath('//evening_phone').text.strip
  end

  def phone
    @phone = day_phone || evening_phone
  end

  def card_type
    @card_type ||= @xml.xpath('//card_type').text
  end

  def order_type
    @order_type ||= @xml.xpath('//order_type').text
  end

  def subtotal
    @subtotal ||= @xml.xpath('//subtotal').text
  end

  def tax_rate
    @tax_rate ||= @xml.xpath('//tax_rate').text.to_f
  end

  def tax
    @tax ||= @xml.xpath('//tax').text
  end

  def shipping_handling_total
    @shipping_handling_total ||= @xml.xpath('//shipping_handling_total').text
  end

  def total
    @total ||= @xml.xpath('//total').text
  end

  def payment_method
    @payment_method ||= @xml.xpath('//payment_method').text
  end

  def payment_method_type
    case order_type
    when 'credit card'
      card_type
    when 'purchase order'
     amazon_order? ? 'Amazon' : payment_method
    else
      payment_method
    end
  end

  def line_items
    xpath = %w(item_id quantity description unit_cost_with_discount total_cost_with_discount).collect { |l| "//item/#{l}" }.join(' | ')
    @line_items ||= @xml.xpath(xpath).collect { |i| i.text }.each_slice(5).to_a
  end

  def to_bool(text)
    text.strip.downcase[0] == 'y'
  end
end

class UltraCartAddress
  include Carmen

  def initialize(xml, base)
    @xml = xml
    @base = base
  end

  def company
    @company ||= @xml.xpath("//#{@base}_to_company").text.strip
  end

  def title
    @title ||= @xml.xpath("//#{@base}_to_title").text.strip
  end

  def first_name
    @first_name ||= @xml.xpath("//#{@base}_to_first_name").text.strip
  end

  def last_name
    @last_name ||= @xml.xpath("//#{@base}_to_last_name").text.strip
  end

  def address1
    @address1 ||= @xml.xpath("//#{@base}_to_address1").text.strip
  end

  def address2
    @address2 ||= @xml.xpath("//#{@base}_to_address2").text.strip
  end

  def city
    @city ||= @xml.xpath("//#{@base}_to_city").text.strip
  end

  def state
    @state ||= @xml.xpath("//#{@base}_to_state").text.strip
  end

  def zip
    @zip ||= @xml.xpath("//#{@base}_to_zip").text.strip
  end

  def country
    @country ||= @xml.xpath("//#{@base}_to_country").text.strip
  end

  def country_code
    @country_code ||= Country.named(country).alpha_2_code
  end
end
