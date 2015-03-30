class RaceController < ApplicationController
    def index
        races = RacerRace.order('created_at desc').limit(1000).group_by(&:race_start)

        @races = []
        day = nil
        races.keys.sort.reverse.each do |race_start|
            break if race_start.day != day && day.present?
            day = race_start.day
            race = races[race_start]
            race.sort_by! { |racer| racer['best_time'] }
            @races << race
        end
    end
end
