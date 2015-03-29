class RacerController < ApplicationController
    def show
        @racer = resolve_racer_by_id(params[:id])

        @races_by_kart_type = RacerRace.where(racer_id: @racer.racer_id).order('kart_type, best_time asc').all.group_by(&:kart_type)
    end

    def versus
        @racer1 = resolve_racer_by_id(params[:id1])
        @racer2 = resolve_racer_by_id(params[:id2])

        @races = RacerRace.where(racer_id: [@racer1.racer_id, @racer2.racer_id]).group_by(&:race_id)
        @races.reject! { |k, racers| racers.size < 2 || racers.first.kart_type != racers.second.kart_type }
    end

    private

    def resolve_racer_by_id(id)
        racer = RacerRace.find_by(racer_id: id)
        racer = RacerRace.find_by(nickname: id) if racer.nil?
        racer
    end
end