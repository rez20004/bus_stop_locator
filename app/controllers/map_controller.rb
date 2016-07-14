require './lib/modules/locatable.rb'

class MapController < ApplicationController
  before_action :authenticate_user!

  def create
    place = params[:map][:location]
    @place = place.strip.gsub(/\s/,'+')
    lat_and_long_call
    @closest = Station.closest_to(@latitude.to_f, @longitude.to_f)
  end

  private
  def lat_and_long_call
    data = HTTParty.get "https://maps.googleapis.com/maps/api/place/textsearch/xml?query=#{@place}&key=#{ENV['GOOGLE_PLACES_KEY2']}"
    @latitude = data["PlaceSearchResponse"]["result"]["geometry"]["location"]["lat"]
    @longitude = data["PlaceSearchResponse"]["result"]["geometry"]["location"]["lng"]
  end
end
