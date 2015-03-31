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
        @racers.each { |racer| racer['times'] = [] }
        # @best_averages = [normal_karts, fast_karts, kids_karts].map do |karts|
        #   karts.map { |racers| racers["average"] }.min
        # end

        # @best_bests = [normal_karts, fast_karts, kids_karts].map do |karts|
        #   karts.map { |racers| racers["best"] }.min
        # end
    end
end
