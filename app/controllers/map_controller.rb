require './lib/modules/locatable.rb'

class MapController < ApplicationController
  before_action :authenticate_user!

  def create
    place = params[:map][:location]
    @place = place.strip.gsub(/\s/,'+')
    data = HTTParty.get "https://maps.googleapis.com/maps/api/place/textsearch/xml?query=#{place}&key=#{ENV['GOOGLE_PLACES_KEY2']}"
    @latitude = data["PlaceSearchResponse"]["result"].first["geometry"]["location"]["lat"]
    @longitude = data["PlaceSearchResponse"]["result"].first["geometry"]["location"]["lng"]
    # @name = data["PlaceSearchResponse"]["result"]["name"]
    @closest = Station.closest_to(@latitude.to_f, @longitude.to_f)
  end
end
