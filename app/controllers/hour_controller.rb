class HourController < ApplicationController
    def races
        @day_hour_racers = RacerRace.select('race_start, count(*) as racers').where('race_id in (?)', RacerRace.select('distinct(race_id)').where('race_start >= ?', 7.days.ago)).group('race_start').group_by { |race| race.race_start.wday }

        @day_hour_racers.each do |wday, racers|
            @day_hour_racers[wday] = racers.group_by { |race| race.race_start.hour }
            @day_hour_racers[wday].each do |hour, racers|
                @day_hour_racers[wday][hour] = (racers.map(&:racers).sum.to_f / racers.size).round
                # raise "#{races.map(&:racers).sum.to_f} #{races.map(&:racers).join(",")}" if races.map(&:racers).sum.to_f > 5
            end
        end
    end
end
