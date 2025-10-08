class WeatherService
  include HTTParty
  base_uri "https://api.openweathermap.org/data/2.5"

  def initialize(lat, lng)
    @lat = lat
    @lng = lng
  end

  def current_state
    response = self.class.get('/weather', query: {
      lat: @lat,
      lon: @lng,
      appid: ENV['FORECAST_API_KEY'],
      units: 'metric'
    })
    debugger
    return nil unless response.success?

    data = response.parsed_response
    {
      temperature: data.dig('main', 'temp'),
      high: data.dig('main', 'temp_max'),
      low: data.dig('main', 'temp_min'),
      description: data.dig('weather', 0, 'description')
    }
  end  
end 
#19.310711618138406, 84.77851367075601