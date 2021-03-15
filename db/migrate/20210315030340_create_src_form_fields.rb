class CreateSrcFormFields < ActiveRecord::Migration[5.1]
  def change
    create_table :src_form_fields do |t|
      t.text :data
      t.timestamps
    end
  end
end
