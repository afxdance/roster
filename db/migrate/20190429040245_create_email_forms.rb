class CreateEmailForms < ActiveRecord::Migration[5.1]
  def change
    create_table :email_forms do |t|
      t.string :subject
      t.text :body

      t.timestamps
    end
  end
end
