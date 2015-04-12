class RacerController < ApplicationController
    def show
        @racer = resolve_racer_by_id(params[:id])

        @races_by_kart_type = RacerRace.where(racer_id: @racer.racer_id).order('kart_type, best_time asc').group_by(&:kart_type)

        @coracers = RacerRace.where(race_id: RacerRace.where(racer_id: @racer.racer_id).pluck(:race_id)).where('racer_id <> ?', @racer.racer_id).group_by(&:racer_id)
    end

    def versus
        @racer1 = resolve_racer_by_id(params[:id1])
        @racer2 = resolve_racer_by_id(params[:id2])

        @races = RacerRace.where(racer_id: [@racer1.racer_id, @racer2.racer_id]).group_by(&:race_id)
        @races.reject! { |k, racers| racers.size < 2 || racers.first.kart_type != racers.second.kart_type }

        @coracers = RacerRace.where(race_id: RacerRace.where(racer_id: @racer1.racer_id).pluck(:race_id)).where('racer_id <> ?', @racer1.racer_id).where('racer_id <> ?', @racer2.racer_id).group_by(&:racer_id)
    end

    def search
        query_args = params[:q].downcase.gsub(/[^a-z0-9]/, '%').split(/ /)

        racers = RacerRace.select('distinct(racer_id)')
        query_args.each do |query_arg|
            racers = racers.where('nickname ilike ?', "%#{query_arg}%")
        end

        racers_id = racers.limit(20).pluck(:racer_id)

        @racers = RacerRace.where(racer_id: racers_id).select('racer_id, nickname').group('racer_id, nickname').order('max(race_start) desc')
    end

    private

    def resolve_racer_by_id(id)
        racer = nil
        racer = RacerRace.find_by(racer_id: id.to_i) unless id.to_i == 0 && id != "0"
        racer = RacerRace.find_by(nickname: id) if racer.nil?

        racer
    end
end
