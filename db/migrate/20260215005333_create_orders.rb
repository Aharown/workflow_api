class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.string :status, null: false, default: 'pending'
      t.decimal :total_amount, precision: 10, scale: 2

      t.timestamps
    end
  end
end
