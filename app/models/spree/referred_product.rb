class Spree::ReferredProduct < ActiveRecord::Base
  belongs_to :product
  belongs_to :referred_order
end
