class Ticket < ApplicationRecord
  REQUEST_TYPES = %w(normal).freeze

  has_one :excavator

  validates :sequence_number, uniqueness: true
  validates :request_type, inclusion: {in: REQUEST_TYPES}
  validates :request_number, format: {with: /\A\d+-\d+\Z/}
  validates :request_number, :sequence_number, :request_type, :response_due, :primary_sacode, presence: true
  validate :validate_polygon_in_well_known_text

  scope :with_poly, -> { select('*, ST_PolygonFromText(well_known_text) AS poly') }

  def request_type=(value)
    write_attribute(:request_type, value.downcase) if value
  end

  def poly_json
    {"type": "FeatureCollection",
      "features": [
        {"type": "Feature",
          "geometry": RGeo::GeoJSON.encode(poly).as_json
        }
      ]
    }
  end

  def validate_polygon_in_well_known_text
    wkt_value = ActiveRecord::Base.connection.quote(well_known_text)
    ActiveRecord::Base.connection.execute("SELECT ST_PolygonFromText(#{wkt_value});")
  rescue ActiveRecord::StatementInvalid => e
    if e.cause.is_a?(PG::InternalError)
      errors.add(:well_known_text, :invalid)
    end
  end
end
