class RacerRaceIncreaseBestTimePrecision < ActiveRecord::Migration
  def change
    change_column :racer_races, :best_time, :decimal, scale: 3, precision: 10
  end
end
