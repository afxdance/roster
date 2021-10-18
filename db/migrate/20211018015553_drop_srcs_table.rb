class DropSrcsTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :srcs
  end
end
