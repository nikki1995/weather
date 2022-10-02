class WeatherController < ApplicationController
  FAHRENHEIT_UNIT = 'F'
  CELSIUS_UNIT = 'C'
  CACHE_EXPIRES_AT = 30.minutes

  def new; end

  def show
    return @error_message unless validate_params
    Rails.logger.info("Request received for Zipcode #{permitted_params[:zipcode]}")
    @cached = false
    @degree = weather_degree
    @current_weather = get_current_weather
    @weather_forecast = get_weather_forecast
  end

  # https://openweathermap.org/current#data
  def get_units
    permitted_params[:unit] == FAHRENHEIT_UNIT ? 'imperial' : 'metric'
  end

  def weather_degree
    permitted_params[:unit] == FAHRENHEIT_UNIT ? '°F' : '°C'
  end

  # https://openweathermap.org/current#zip
  def get_current_weather
    cache_key = "current_weather_#{permitted_params[:zipcode]}_#{get_units}"
    url = ENV['API_URL'] + "/data/2.5/weather?zip=#{permitted_params[:zipcode]},us&appid=#{ENV['API_KEY']}&units=#{get_units}"
    data = http_call(url)
    write_to_cache(cache_key, data)
    data
  end

  def get_weather_forecast
    cache_key = "weather_forecast_#{permitted_params[:zipcode]}_#{get_units}"
    url = ENV['API_URL'] + "/data/2.5/forecast?zip=#{permitted_params[:zipcode]},us&cnt=6&appid=#{ENV['API_KEY']}&units=#{get_units}"
    data = http_call(url)
    write_to_cache(cache_key, data)
    data
  end

  private

  def permitted_params
    params.permit(:zipcode, :unit, :commit)
  end

  def write_to_cache(cache_key, data)
    if Rails.cache.exist?(cache_key)
      @cached = true
      return
    end
    Rails.cache.write(cache_key, data, expires_in: CACHE_EXPIRES_AT) unless %w(401).include?(data['cod']) || @error_message.present? # Add more error codes if applicable
  end

  def validate_params
    if permitted_params[:zipcode].blank? || !permitted_params[:zipcode].match?(/^\d{5}(-\d{4})?$/)
      @error_message = 'please enter a valid US 5 digit zipcode'
      return false
    end
    true
  end

  def http_call(url)
    begin
      response =  Net::HTTP.get_response(URI(url))
      if response.present?
        JSON.parse(response.body)
      else
        raise 'Something went wrong. Please try again later'
      end
    rescue StandardError => ex
      Rails.logger.error("Error in making GET request to #{url}, message - #{ex.try(:message)}, backtrace - #{ex.try(:backtrace)}")
      @error_message = ex.message
    end
  end

end
