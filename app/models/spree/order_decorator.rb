module Spree
  Order.class_eval do
    has_one :referred_order
  end
end