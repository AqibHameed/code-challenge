class CreateUnits < ActiveRecord::Migration[5.2]
  def change
    create_table :units do |t|
      t.string :asset_id, index: true
      t.integer :size
      t.boolean :is_rented
      t.integer :rent
      t.integer :unit_type
      t.string :tenant
      t.datetime :lease_start
      t.datetime :lease_end
      t.string :unit_ref

      t.timestamps
    end
  end
end
