#!/usr/bin/env ruby

require 'net/http'
require 'json'
require 'time'
require 'set'

next_date = "2015-01-01"
most_recent = RacerRace.order('race_start desc').limit(1).first
next_date = most_recent.race_start.strftime("%Y-%m-%d") if most_recent

races_list_url = URI("http://sirtigard.clubspeedtiming.com/api/index.php/races/since.json?&date=#{next_date}&limit=500&key=cs-dev")
races_list_response = Net::HTTP.get(races_list_url)

races = JSON.parse(races_list_response)['races']

races = races[10..-1]

class InvalidRacerId < StandardError ; end 

races.each do |race|
    race_id = race['race_id'].to_i

    puts race_id
    next if RacerRace.where(race_id: race_id).exists?

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

                best_time = nil
                (racer["laps"] || []).each do |lap|
                    lap_time = lap["lap_time"]
                    next if lap_time <= 0
                    best_time = lap_time if best_time.nil? || best_time > lap_time
                end

                if best_time
                    puts "racer_id: #{racer_id}, race_id: #{race_id} best_time: #{best_time}"
                    RacerRace.create!(racer_id: racer_id, race_id: race_id, race_start: race_start, nickname: nickname, best_time: best_time, kart_number: kart_number, kart_type: kart_type)
                end
            end
        rescue InvalidRacerId
            puts "skipping (invalid racer id)"
        end
    end

end