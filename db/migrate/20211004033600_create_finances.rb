class CreateFinances < ActiveRecord::Migration[5.1]
  def change
    create_table :finances do |t|
      t.boolean :dues
      t.boolean :tickets
      t.text :dues_approved
      t.text :tickets_approved
      t.datetime :dues_updated
      t.datetime :tickets_updated

      t.belongs_to :dancer
    end
  end
end
