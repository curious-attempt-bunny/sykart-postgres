class RacerController < ApplicationController
    def show
        @racer = RacerRace.find_by(racer_id: params[:id].to_i)
        @racer = RacerRace.find_by(nickname: params[:id].to_s) if @racer.nil?

        @races_by_kart_type = RacerRace.where(racer_id: @racer.racer_id).order('kart_type, best_time asc').all.group_by(&:kart_type)
    end
end
