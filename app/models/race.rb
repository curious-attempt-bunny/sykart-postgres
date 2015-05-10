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
        race_response = Rails.cache.fetch("race/#{race_id}", expires_in: 7.days) do
            race_url = URI("http://sirtigard.clubspeedtiming.com/api/index.php/races/#{race_id}.json?key=cs-dev")
            Net::HTTP.get(race_url)
        end
        race = JSON.parse(race_response)['race']
        # puts JSON.pretty_generate(race)
    
        race["starts_at"] = Time.zone.parse(race["starts_at"])

        # Sometimes the racers are represented in the form {"0" => {...}, "1" => {...}}
        race["racers"] = race["racers"].values if race["racers"].values rescue false

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
            racer["nickname"] = racer["nickname"][0..39] # Max length is 40

            total_time = 0
            laps = 0
            best_time = nil
            racer["laps"].each do |lap|
                lap_time = lap["lap_time"]
                best_time = lap_time if best_time.nil? || best_time > lap_time
                total_time += lap_time
                laps += 1
            end
            if best_time
                racer['average_time'] = (total_time / laps).round(3)
                racer['best_time'] = best_time
            end
        end

        race["racers"].reject! { |racer| racer["laps"].empty? }
        race["racers"].sort_by! { |racer| racer["best_time"] }

        race
    end
end