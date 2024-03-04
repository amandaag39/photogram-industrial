class AddDefaultToPhotosCount < ActiveRecord::Migration[7.0]
  def change
    change_column_default(
    :users,
    :photos_count,
    from: nil, # only if you want to explicitly show the change from a previous state
    to: 0
  )
  end
end
