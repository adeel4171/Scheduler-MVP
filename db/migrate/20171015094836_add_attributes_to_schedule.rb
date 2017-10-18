class AddAttributesToSchedule < ActiveRecord::Migration[5.1]
  def change
  	add_column :schedules, :user_id, :integer
  	add_column :schedules, :days, :string 
  	add_column :schedules, :repeat_to, :date
  end
end
