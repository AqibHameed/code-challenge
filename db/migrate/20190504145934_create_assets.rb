class CreateAssets < ActiveRecord::Migration[5.2]
  def change
    create_table :assets do |t|
      t.integer :portfolio_id, index: true
      t.string :address
      t.integer :zipcode
      t.string :city
      t.boolean :is_restricted
      t.integer :yoc
      t.string :asset_ref
      t.datetime :date

      t.timestamps
    end
  end
end
