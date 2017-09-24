class AddUserIdToSpreeAffiliate < ActiveRecord::Migration
  def change
    add_column :spree_affiliates, :user_id, :integer
  end
end
