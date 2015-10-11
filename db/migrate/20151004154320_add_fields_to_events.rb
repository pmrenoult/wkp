class AddFieldsToEvents < ActiveRecord::Migration
  def change
  	add_column :events, :title, :string
    add_column :events, :time_begin, :time
    add_column :events, :time_end, :time
  	add_column :events, :date_begin, :date
  	add_column :events, :date_end, :date
  end
end
