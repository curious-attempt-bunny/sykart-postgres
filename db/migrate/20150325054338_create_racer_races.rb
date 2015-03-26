class CreateRacerRaces < ActiveRecord::Migration
  def change
    create_table :racer_races do |t|
      t.integer :racer_id
      t.integer :race_id
      t.timestamp :race_start
      t.string :nickname, limit: 30
      t.decimal :best_time, scale: 3, precision: 6
      t.integer :kart_number
      t.string :kart_type

      t.timestamps

      t.index [:race_id]
      t.index [:racer_id, :race_id], unique: true
      t.index [:racer_id, :best_time, :kart_type]
    end
  end
end
