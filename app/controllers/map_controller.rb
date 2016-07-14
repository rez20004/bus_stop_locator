require './lib/modules/locatable.rb'

class MapController < ApplicationController
  before_action :authenticate_user!

  def create
    place = params[:map][:location]
    @place = place.strip.gsub(/\s/,'+')
    data = HTTParty.get "https://maps.googleapis.com/maps/api/place/textsearch/xml?query=#{place}&key=#{ENV['GOOGLE_PLACES_KEY2']}"
    binding.pry
      @latitude = data["PlaceSearchResponse"]["result"]["geometry"]["location"]["lat"]
      binding.pry
      @longitude = (data["PlaceSearchResponse"]["result"])["geometry"]["location"]["lng"]
      @name = data["PlaceSearchResponse"]["result"]["name"]
      binding.pry
    @closest = Station.closest_to(@latitude.to_i, @longitude.to_i)
  end
end
