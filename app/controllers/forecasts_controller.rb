class ForecastsController < ApplicationController

  def show
    address = params[:address]
    return render json: {error: 'Address required'}, status: 400 unless address.present?

    cache_key = "forecast_#{address.parameterize}"
    forecast_data = Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
      geocode = GeocodeService.new(address).call
      next nil unless geocode
      WeatherService.new(geocode[:lat], geocode[:lng]).current_state
    end
    if forecast_data
      render json: { cached: !Rails.cache.read(cache_key).nil?, forecast: forecast_data }
    else
      render json: { error: 'Unable to fetch forecast' }, status: 404
    end    
  end  
end
