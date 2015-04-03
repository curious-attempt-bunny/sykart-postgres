class HourController < ApplicationController
    def races
        @day_hour_racers = RacerRace.select('race_start, count(*) as racers').where('race_id in (?)', RacerRace.select('distinct(race_id)').where('race_start >= ?', 1.month.ago)).group('race_start').group_by { |race| race.race_start.wday }

        @day_hour_racers.each do |wday, racers|
            @day_hour_racers[wday] = racers.group_by { |race| race.race_start.hour }
            @day_hour_racers[wday].each do |hour, racers|
                @day_hour_racers[wday][hour] = (racers.map(&:racers).sum.to_f / racers.size).round
            end
        end
    end

    def qualifiers
        @day_hour_racers = RacerRace.where('best_time <= ?', 30.825).where('race_start >= ?', 7.days.ago).where(kart_type: "normal").group_by { |race| race.race_start.wday }

        @day_hour_racers.each do |wday, racers|
            @day_hour_racers[wday] = racers.group_by { |race| race.race_start.hour }
            @day_hour_racers[wday].each do |hour, racers|
                @day_hour_racers[wday][hour] = racers.size
            end
        end
    end
end
