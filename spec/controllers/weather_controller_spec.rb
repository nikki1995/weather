require "rails_helper"

RSpec.describe WeatherController, type: :controller do
  describe "GET weather data by Zipcode" do
    it "returns error message if invalid params are passed" do
      params = {}
      get :show, params: params

      expect(@controller.instance_variable_get(:@error_message)).to eq("please enter a valid US 5 digit zipcode")
    end

    it "returns error message if invalid params are passed" do
      params = { 'zipcode' => '2201d', 'unit' => 'Fahrenheit'}
      get :show, params: params

      expect(@controller.instance_variable_get(:@error_message)).to eq("please enter a valid US 5 digit zipcode")
    end

    it "returns city not found if invalid zipcode is sent" do
      params = { 'zipcode' => '00000', 'unit' => 'Fahrenheit'}
      get :show, params: params
      expect(@controller.instance_variable_get(:@current_weather)).to eq({"cod"=>"404", "message"=>"city not found"})
    end

    it "returns valid response if valid zipcode is sent" do
      params = { 'zipcode' => '95014', 'unit' => 'Fahrenheit'}
      get :show, params: params
      expect(@controller.instance_variable_get(:@current_weather)['name']).to eq('Cupertino')
    end

    it "returns imperial as unit when Fahrenheit measurement_unit is passed" do
      params = { 'zipcode' => '95014', 'unit' => 'F'}
      get :show, params: params
      expect(@controller.instance_variable_get(:@degree)).to eq('°F')
    end
  end
end
