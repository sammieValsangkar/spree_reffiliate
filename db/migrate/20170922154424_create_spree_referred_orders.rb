class CreateSpreeReferredOrders < ActiveRecord::Migration
  def change
    create_table :spree_referred_orders do |t|
      t.integer :affiliate_id, add_index: true
      t.integer :user_id, add_index: true
      t.integer :order_id, add_index: true
      t.integer :referral_id, add_index: true
      t.timestamps
    end
  end
end
