ActiveAdmin.register Calendar2 do
  if Calendar2.table_exists?
    columns = Calendar2.columns.map(&:name).map(&:to_sym)
    permit_params columns
  end

  index do
    selectable_column
    id_column
    column :event
    column :time
    column :location
    actions
  end
  # end
  # create_table :products do |t|
  #   t.string :name
  # end
end
