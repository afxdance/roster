class CreateFinances < ActiveRecord::Migration[5.1]
  def change
    create_table :finances do |t|
      t.boolean :dues
      t.boolean :tickets
      t.text :dues_approved
      t.text :tickets_approved

      t.belongs_to :dancer
      t.timestamps
    end
  end
end
