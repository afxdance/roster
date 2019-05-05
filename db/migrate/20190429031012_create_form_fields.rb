class CreateFormFields < ActiveRecord::Migration[5.1]
  def self.up
    create_table :form_fields do |t|
      t.text :text
      t.string :identity
      t.timestamps
    end
    add_index :active_admin_comments, [:identity]
  end

  def self.down
  	drop_table :form_fields
  end
end

