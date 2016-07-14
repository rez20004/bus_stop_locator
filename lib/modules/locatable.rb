require 'pry'
require 'haversine'

module Locatable
  def Locatable.included other
    other.extend Locatable::ClosestStation
  end

  module ClosestStation
    def closest_to(lat, long)
      @lat = lat
      @long = long
      station_correlation = {}
      unless self.all.nil?
        self.all.each do |station|
          station_correlation[station] = (
          Haversine.distance(station.latitude, station.longitude, lat, long).to_miles
          )
        end
        station_correlation = station_correlation.sort_by{ |k, v| v }
        return station_correlation.first.first
      end
      # I did not find any bus stations at that location. Please try another
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
  def initialize(lat, long)
    @latitude, @longitude = lat, long
  end

  def self.all
    data = HTTParty.get "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{@lat},#{@long}
      &radius=50000
      &type=bus_station
      &name=bus
      &key=#{ENV['GOOGLE_PLACES_KEY2']}"
    data['results'].map do |f|
      Station.new f['geometry']['location']['lat'],
                  f['geometry']['location']['lng']
    end
  end
end
