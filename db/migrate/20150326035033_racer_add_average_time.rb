class RacerAddAverageTime < ActiveRecord::Migration
  def change
    add_column :racer_races, :average_time, :decimal, scale: 3, precision: 10
  end
end
