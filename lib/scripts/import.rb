#!/usr/bin/env ruby

require 'net/http'
require 'json'
require 'time'
require 'set'

class InvalidRacerId < StandardError ; end 

Race.unimported.each do |race_id|
    # TODO next if already recorded

    race_url = URI("http://sirtigard.clubspeedtiming.com/api/index.php/races/#{race_id}.json?key=cs-dev")
    race_response = Net::HTTP.get(race_url)
    # puts race_response
    race = JSON.parse(race_response)['race']
    # puts JSON.pretty_generate(race)

    race_start = Time.zone.parse(race["starts_at"])
    puts race_start

    ActiveRecord::Base.transaction do
        begin
            race["racers"].each do |racer|
                racer_id =
                    begin 
                        racer["id"].to_i
                    rescue
                        raise InvalidRacerId
                    end
                kart_number = racer["kart_number"].to_i
                kart_type = "normal"
                if kart_number >= 40 
                    kart_type = "slow"
                elsif kart_number >= 20
                    kart_type = "fast"
                end
                nickname = racer["nickname"]

                total_time = 0
                laps = 0
                best_time = nil
                (racer["laps"] || []).each do |lap|
                    lap_time = lap["lap_time"]
                    next if lap_time <= 0
                    best_time = lap_time if best_time.nil? || best_time > lap_time
                    # puts "lap_time: #{lap_time}"
                    total_time += lap_time
                    laps += 1
                end

                if best_time
                    average_time = (total_time / laps).round(3)
                    puts "racer_id: #{racer_id}, race_id: #{race_id} best_time: #{best_time} average_time: #{average_time}"
                    RacerRace.create!(racer_id: racer_id, race_id: race_id, race_start: race_start, nickname: nickname, best_time: best_time, average_time: average_time, kart_number: kart_number, kart_type: kart_type)
                end
            end
        rescue InvalidRacerId
            puts "skipping (invalid racer id)"
        end
    end

end