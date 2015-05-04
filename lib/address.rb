module WombatObjects
  module Address
    def phone
      @ultracart_order.day_phone || @ultracart_order.evening_phone
    end

    def address(ultracart_address)
      {
        firstname: ultracart_address.first_name,
        lastname:  ultracart_address.last_name,
        address1:  ultracart_address.address1,
        address2:  ultracart_address.address2,
        zipcode:   ultracart_address.zip,
        city:      ultracart_address.city,
        state:     ultracart_address.state,
        country:   ultracart_address.country_code,
        phone:     phone
      }
    end
  end
end
