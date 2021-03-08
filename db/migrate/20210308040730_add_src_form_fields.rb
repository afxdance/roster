class AddSrcFormFields < ActiveRecord::Migration[5.1]
  def change
    create_table :src_form_fields do |t|
      t.text :title
      t.text :header
      t.text :intro
    end
  end
end
