require 'net/http'

class Race
    def self.unimported
        next_date = "2015-01-01"
        most_recent = RacerRace.order('race_start desc').limit(1).first
        next_date = most_recent.race_start.strftime("%Y-%m-%d") if most_recent

        races_list_url = URI("http://sirtigard.clubspeedtiming.com/api/index.php/races/since.json?&date=#{next_date}&limit=500&key=cs-dev")
        races_list_response = Net::HTTP.get(races_list_url)

        races = JSON.parse(races_list_response)['races']

        race_ids = races.map { |race| race['race_id'].to_i }
        race_ids.reject do |race_id|
            RacerRace.where(race_id: race_id).exists?
        end
    end

    def self.load(race_id)
        race_url = URI("http://sirtigard.clubspeedtiming.com/api/index.php/races/#{race_id}.json?key=cs-dev")
        race_response = Net::HTTP.get(race_url)
        race = JSON.parse(race_response)['race']
    
        race["starts_at"] = Time.zone.parse(race["starts_at"])

        race["racers"].each do |racer|
            racer["id"] = racer["id"].to_i
            racer["kart_number"] = racer["kart_number"].to_i
            racer["kart_type"] = if racer["kart_number"] >= 40 
                    "slow"
                elsif racer["kart_number"] >= 20
                    "fast"
                else
                    "normal"
                end
            racer["laps"] = racer["laps"] || []
            racer["laps"].reject! { |lap| lap["lap_time"] <= 0 }
        end

        race["racers"].reject! { |racer| racer["laps"].empty? }

        race
    end
end