# 1 LAW OF DEMETER
# lays out the concept that an object can call methods on a related object but that it should not
# reach through that object to call a method on a third

class Address
  attr_accessor :street, :city, :state
  belongs_to :customer
end

class Customer
  has_one :address
  has_one :invoice

  delegate :street, :city, :state, to: :address
end

class Invoice
  belongs_to :customer

  delegate :street,
           :city,
           :state,
           to: :customer,
           prefix: true
end
# By passing the attributes, we can now use invoice.customer_name
