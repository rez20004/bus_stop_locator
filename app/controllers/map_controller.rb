require './lib/modules/locatable.rb'

class MapController < ApplicationController
  before_action :authenticate_user!

  def create
    place = params[:map][:location]
    @place = place.strip.gsub(/\s/,'+')
    data = HTTParty.get "https://maps.googleapis.com/maps/api/place/textsearch/xml?query=#{place}&key=#{ENV['GOOGLE_PLACES_KEY']}"
    begin
      @latitude = Array(data["PlaceSearchResponse"]["result"]).first["geometry"]["location"]["lat"]
      @longitude = Array(data["PlaceSearchResponse"]["result"]).first["geometry"]["location"]["lng"]
      @name = Array(data["PlaceSearchResponse"]["result"]).first["name"]

    rescue
      puts "that is not a valid place. Please be more specific"
    end
    @closest = Station.closest_to(@latitude.to_i, @longitude.to_i)
  end
end
