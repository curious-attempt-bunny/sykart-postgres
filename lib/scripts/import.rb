#!/usr/bin/env ruby

Race.unimported.each do |race_id|
    race = Race.load(race_id)

    ActiveRecord::Base.transaction do
        begin
            race["racers"].each do |racer|
                total_time = 0
                laps = 0
                best_time = nil
                racer["laps"].each do |lap|
                    lap_time = lap["lap_time"]
                    best_time = lap_time if best_time.nil? || best_time > lap_time
                    total_time += lap_time
                    laps += 1
                end

                if best_time
                    average_time = (total_time / laps).round(3)
                    puts "starts_at: #{race['starts_at']} racer_id: #{racer['id']}, race_id: #{race_id} best_time: #{best_time} average_time: #{average_time}"
                    RacerRace.create!(racer_id: racer['id'], race_id: race_id, race_start: race['starts_at'], nickname: racer['nickname'], best_time: best_time, average_time: average_time, kart_number: racer['kart_number'], kart_type: racer['kart_type'])
                end
            end
        end
    end
end