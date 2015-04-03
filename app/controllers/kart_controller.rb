class KartController < ApplicationController
    def index
        @karts = Hash[RacerRace.select('kart_number').where('kart_type = ?', 'normal').group(:kart_number).pluck(:kart_number).map do |kart_number|
            times = RacerRace.select(:best_time).where('race_start >= ?', 14.days.ago).where(kart_number: kart_number).order('best_time asc').limit(10).pluck(:best_time)
            [kart_number, times.sum / times.size] unless times.empty? || kart_number == 0
        end.compact]
    end
end
