class Spree::ReferredOrder < ActiveRecord::Base
  belongs_to :order
  belongs_to :affiliate
  belongs_to :referral
  belongs_to :user, class_name: Spree.user_class.to_s
  has_many :referred_products
end

