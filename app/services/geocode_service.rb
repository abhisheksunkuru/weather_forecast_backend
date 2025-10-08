class GeocodeService
  include HTTParty
  base_uri 'https://api.opencagedata.com/geocode/v1/json'

  def initialize(address)
    @address = address
  end  

  def call
    response = self.class.get('', query: { q: @address, key: ENV['GEO_CODE_API_KEY'] })
    return nil unless response.success?

    location = response.parsed_response.dig('results', 0, 'geometry')
    location ? { lat: location['lat'], lng: location['lng'] } : nil
  end  

end  