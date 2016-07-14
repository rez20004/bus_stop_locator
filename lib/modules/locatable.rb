require 'pry'
require 'haversine'

module Locatable
  def Locatable.included other
    other.extend Locatable::ClosestStation
  end

  module ClosestStation
    def closest_to(lat, long)
      station_correlation = {}
      self.all.each do |station|
        station_correlation[station] = (Haversine.distance(station.latitude, station.longitude, lat, long).to_miles)
      end
      station_correlation = station_correlation.sort_by{ |k, v| v }
      return station_correlation.first.first
    end

  end
  def distance_to(lat, long)
    distance = Haversine.distance(self.latitude, self.longitude, lat, long)
    distance.to_miles
  end
end

class Station
  attr_reader :latitude, :longitude

  include Locatable

  def initialize lat, long
    @latitude, @longitude = lat, long
  end

  def self.all
    data = HTTParty.get "https://maps.googleapis.com/maps/api/place/textsearch/xml?query=bus+stop&key=#{ENV['GOOGLE_PLACES_KEY2']}&type=bus_station"

    data["PlaceSearchResponse"]["result"].map do |f|
      Station.new f["geometry"]["location"]["lat"].to_f, f["geometry"]["location"]["lng"].to_f
    end

  end
end
