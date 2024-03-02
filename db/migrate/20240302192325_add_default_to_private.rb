class AddDefaultToPrivate < ActiveRecord::Migration[7.0]
  def change
    change_column_default(
      :users,     # table_name
      :private,   # column_name
      from: nil,  # previous default value, if any
      to: false   # new default value
    )
  end
end

