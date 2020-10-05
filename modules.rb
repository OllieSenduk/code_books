# Here we have taken out methods that belong to an order and moved them
# to their own modules

# app/models/order.rb
class Order < ActiveRecord::Base
  # extend becomes class methods -> thus can use self as the object
  extend OrderStatefinders
  extend OrderSearchers

  # Include becomes instance methods -> thus can use self as the object
  include OrderExporters
end

# lib/order_state_finders.rb
module OrderStatefinders
  def find_purchased
    Order.where(status: 'purchased')
  end

  def find_waiting_for_review
    Order.where(status: 'waiting_for_review')
  end
end

# lib/order_searches.rb
module OrderSearches
  def advanced_search(fields, options = {}); end
end

# lib/order_exporters.rb
module OrderSearches
  def to_xml; end

  def to_pdf; end
end
