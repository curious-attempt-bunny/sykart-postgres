class RacerNicknameLength < ActiveRecord::Migration
  def change
    change_column :racer_races, :nickname, :string,  :limit => 40
  end
end
