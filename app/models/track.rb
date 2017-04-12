# == Schema Information
#
# Table name: tracks
#
#  id                     :integer          not null, primary key
#  rental_id              :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  recording_file_name    :string
#  recording_content_type :string
#  recording_file_size    :integer
#  recording_updated_at   :datetime
#  mileage                :float            default("0.0")
#

require 'google_maps_service'
require 'csv'

class Track < ActiveRecord::Base

  MAX_ANGLE = 15
  MAX_DISTANCE_ANGLE = 1000
  MAX_DISTANCE = 50

  belongs_to :rental

  has_attached_file :recording
  validates_attachment_content_type :recording, content_type: ['text/csv', 'text/plain']

  def calculate_mileage_from_recording(file)

    data = pre_process(file)
    index = 0
    # 1. Filtrage du fichier: les limites de l'API de Google Maps nous impose de sélectionner seulement les points les plus significatifs
    while (index + 2) < data.size
      # étant donné l'échantillonage fréquent et la zone géo limitée, on assimile le problème à un espace de coordonnées cartésien
      loc1 = [data[index]["lat"], data[index]["lng"]]
      loc2 = [data[index + 1]["lat"], data[index + 1]["lng"]]
      loc3 = [data[index + 2]["lat"], data[index + 2]["lng"]]
      dist = distance(loc1, loc2)
      if (dist < MAX_DISTANCE) or (angle(loc1, loc2, loc3) < MAX_ANGLE and dist < MAX_DISTANCE_ANGLE )
        # puts "le conducteur est allé quasiment en ligne droite ou s'est très peu déplacé et on peut supprimer le point intérmédiaire"
        data.delete_at(index + 1)
      else
        index += 1
      end
    end

    # 2. Calcul du kilometrage
    total, index = 0, 0
    while (index + 1) < data.size
      origins = data[index..(index+4)]
      destinations = data[(index+1)..(index+5)]
      # utilisation de l'API google maps pour trouver l'itinéraire routier entre une série de points
      matrix = gmaps.distance_matrix(
        origins,
        destinations,
        mode: 'driving',
        units: 'metric')

      # le kilométrage est la trace du matrice
      total += matrix_trace(matrix)
      index += 5
    end

    self.mileage = total
    self.save
  end

  private

  def pre_process(file)
    # supprimer le temps (1ère colonne)
    file.delete(nil)
    # supprimer les points identiques
    file.map { |d| d.to_hash }.uniq
  end

  def gmaps
    # setup Google Maps
    @gmaps ||= GoogleMapsService::Client.new(
        key: 'AIzaSyAfpvpnf6IOS87J0eDAMm7Vx_-a_VQTtQs',
        retry_timeout: 20,      # Timeout for retrying failed request
        queries_per_second: 10
    )
  end

  def angle loc1, loc2, loc3
    deg_per_rad = 180 / Math::PI
    vector1 = [loc2[0] - loc1[0], loc2[1] - loc1[1]]
    vector2 = [loc3[0] - loc2[0], loc3[1] - loc2[1]]
    dot = vector1[0] * vector2[0] + vector1[1] * vector2[1]
    distance_sum = distance_vec(vector1) * distance_vec(vector2)
    num = [-1, [1, dot / distance_sum].min].max
    deg_per_rad * Math.acos(num)
  end

  def distance_vec(vec)
    Math.sqrt( vec[0] * vec[0] + vec[1] * vec[1])
  end

  def distance loc1, loc2
    rad_per_deg = Math::PI/180  # PI / 180
    rkm = 6371                  # Earth radius in kilometers
    rm = rkm * 1000             # Radius in meters

    dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg  # Delta, converted to rad
    dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg

    lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
    lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

    rm * c # Delta in meters
  end

  # trace matrice envoyé par Google Maps
  def matrix_trace(matrix)
    matrix[:rows].each.with_index.inject(0){|sum,(value, index)| sum + gmaps_distance(value, index) }
  end

  # extraction de la distance entre 2 points de la matrice Google Maps
  def gmaps_distance(row, index)
    row[:elements][index] ? row[:elements][index][:distance][:value] : 0
  end

end
