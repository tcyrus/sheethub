class AddEmailToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :email, :string, limit: 255
  end
end
