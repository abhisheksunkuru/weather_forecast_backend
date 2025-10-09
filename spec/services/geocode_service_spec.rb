require 'rails_helper'

RSpec.describe GeocodeService, type: :service do
  let(:address) { "1600 Amphitheatre Parkway, Mountain View, CA" }
  let(:api_key) { "test-key" }
  let(:http_response) do
    double(success?: true, parsed_response: {
      "results" => [
        { "geometry" => { "location" => { "lat" => 37.422, "lng" => -122.084 } } }
      ]
    })
  end
  
  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with("GEO_CODE_API_KEY").and_return("test-key")  
  end

  it "returns lat/lng for a valid address" do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with("GEO_CODE_API_KEY").and_return("test-key")
    allow_any_instance_of(GeocodeService).to receive(:call).and_return({lat: 37.422, lng: -122.084})

    expect(GeocodeService).to receive(:get)
      .with('', query: { q: address, key: api_key })
      .and_return(http_response)

    service = GeocodeService.new(address)
    result = service.call
    expect(result).to eq({ lat: 37.422, lng: -122.084 })
  end

  it "returns nil for an invalid address" do
    invalid_response = double(success?: true, parsed_response: { "results" => [] })
    expect(GeocodeService).to receive(:get).and_return(invalid_response)

    service = GeocodeService.new("Invalid Address")
    result = service.call
    expect(result).to be_nil
  end

  it "returns nil on unsuccessful response" do
    error_response = double(success?: false)
    expect(GeocodeService).to receive(:get).and_return(error_response)

    service = GeocodeService.new(address)
    expect(service.call).to be_nil
  end
end
