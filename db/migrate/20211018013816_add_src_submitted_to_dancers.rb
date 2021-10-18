class AddSrcSubmittedToDancers < ActiveRecord::Migration[5.1]
  def change
    add_column :dancers, :src_submitted, :boolean
  end
end
