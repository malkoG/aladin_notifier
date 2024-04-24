class CreateMetrics < ActiveRecord::Migration[7.1]
  def change
    create_table :metrics do |t|
      t.references :target, null: false, polymorphic: true
      t.date :date
      t.string :metric_type
      t.integer :amount

      t.timestamps
    end
    add_index :metrics, :date
    add_index :metrics, :metric_type
    add_index :metrics, [:target_id, :target_type, :date, :metric_type]
  end
end
