class KartController < ApplicationController
    def index
        @karts = Hash[RacerRace.select('kart_number').where('kart_type = ?', 'normal').group(:kart_number).pluck(:kart_number).map do |kart_number|
            times = RacerRace.select(:best_time).where('race_start >= ?', 14.days.ago).where(kart_number: kart_number).order('best_time asc').limit(10).pluck(:best_time)
            [kart_number, times.sum / times.size] unless times.empty? || kart_number == 0
        end.compact]
    end

    def index2
        @based_on_races = {}
        @karts = Hash[RacerRace.select('kart_number').where('kart_type = ?', 'normal').group(:kart_number).pluck(:kart_number).map do |kart_number|
            times = RacerRace.select('racer_id, min(best_time) as best_time').where('race_start >= ?', 14.days.ago).where(kart_number: kart_number).group(:racer_id).order('min(best_time)').limit(20)
            data = []
            times.each do |time|
                comparisons = RacerRace.select(:best_time).where('race_start >= ?', 14.days.ago).where('kart_number <> ?', kart_number).where('kart_number < ?', 20).where(racer_id: time.racer_id).order(:best_time).limit(10).pluck(:best_time)
                next if comparisons.size < 3
                racer = RacerRace.select(:nickname).where(racer_id: time.racer_id).first
                @based_on_races[kart_number] ||= []
                @based_on_races[kart_number] << {racer_id: time.racer_id, nickname: racer.nickname, comparison: (comparisons.sum / comparisons.size), best_time: time.best_time}
                data << time.best_time - (comparisons.sum / comparisons.size)
            end
            [kart_number, data.size > 0 ? data.sum / data.size : 0] if kart_number != 0
        end.compact]
    end
end
