class CreateSrcs < ActiveRecord::Migration[5.1]
  def change
    create_table :srcs do |t|
      t.boolean :c1, null: false
      t.boolean :c2, null: false
      t.boolean :c3, null: false
      t.boolean :c4, null: false
      t.boolean :c5, null: false
      t.boolean :c6, null: false
      t.boolean :c7, null: false
      t.boolean :c8, null: false
      t.boolean :c9, null: false
      t.string :pg_release, null: false
      t.string :other, null: true
      t.string :full_name, null: true
      t.string :signature, null: true
      t.string :date, null: true
      t.boolean :acknowledgment, null: true

      t.timestamps

      t.belongs_to :dancer, index: true

    end
  end
end
