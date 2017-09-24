class CreateSpreeReferredProducts < ActiveRecord::Migration
  def change
    create_table :spree_referred_products do |t|
      t.integer :product_id, add_index: true
      t.integer :referred_order_id, add_index: true
      t.timestamps
    end
  end
end
