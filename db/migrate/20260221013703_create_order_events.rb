class CreateOrderEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :order_events do |t|
      t.references :order, null: false, foreign_key: true
      t.string :event_type
      t.jsonb :metadata

      t.timestamps
    end
  end
end
