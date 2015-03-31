#!/usr/bin/env ruby

Race.unimported[0...10].each do |race_id|
    race = Race.load(race_id)

    ActiveRecord::Base.transaction do
        begin
            race["racers"].each do |racer|
                if race['best_time']
                    puts "starts_at: #{race['starts_at']} racer_id: #{racer['id']}, race_id: #{race_id} best_time: #{racer['best_time']} average_time: #{racer['average_time']}"
                    RacerRace.create!(racer_id: racer['id'], race_id: race_id, race_start: race['starts_at'], nickname: racer['nickname'], best_time: racer['best_time'], average_time: racer['average_time'], kart_number: racer['kart_number'], kart_type: racer['kart_type'])
                end
            end
        end
    end
end