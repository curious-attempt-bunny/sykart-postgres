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
end