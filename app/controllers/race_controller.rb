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

    def show
        @race = Race.load(params[:id].to_i)
        @racers = @race["racers"]

        @best_averages = []
        @best_bests = []
        @racers.each do |racer|
            racer['times'] = RacerRace.where(racer_id: racer['id'], kart_type: racer['kart_type']).order('best_time asc').limit(3).map(&:best_time)
        end

        karts = @racers.group_by { |racer| racer['kart_type'] }
        @best_averages = {}
        @best_bests = {}

        karts.each do |kart, racers|
            @best_averages[kart] = racers.map { |racer| racer['average_time'] }.min
            @best_bests[kart] = racers.map { |racer| racer['best_time'] }.min
        end
    end
end
