class Deployment < ActiveRecord::Base
  require 'rgeo/geo_json'
  include PgSearch

  pg_search_scope :search_all,
                  :against => [:model],
                  :using => {
                    :tsearch => {:prefix => true},
                    :trigram => {}
                  },
                  :associated_against => {
                    :otn_array => [ :code,
                                    :description,
                                    :waterbody
                                  ]
                  }

  belongs_to :study
  belongs_to :otn_array
  has_one :retrieval, :dependent => :destroy
  has_many :tag_deployments, :through => :hits

  set_rgeo_factory_for_column(:location, RGeo::Geographic.spherical_factory(:srid => 4326))

  scope :active_study, joins(:study).where('studies.title IS NOT NULL AND studies.name IS NOT NULL AND studies.start IS NOT NULL and studies.ending IS NOT NULL')

  def DT_RowId
    self.id
  end

  def station
    "%03d" % read_attribute(:station) rescue nil
  end

  def rcv_modem_address
    "%03d" % read_attribute(:rcv_modem_address) rescue nil
  end

  def code
    "#{otn_array.code}-#{station}"
  end

  def geo
    return RGeo::GeoJSON.encode(self.location)
  end

  def geojson
    if self.location
      removals = ["location","id","station","otn_array_id"]
      s = self.attributes.delete_if {|key, value| removals.include?(key) }
      s[:code] = code
      s[:recovered] = ending
      s[:otn_array] = {:code => otn_array.code, :description => otn_array.description, :waterbody => otn_array.waterbody, :region => otn_array.region}
      feat = RGeo::GeoJSON::Feature.new(self.location, self.id, s)
      return RGeo::GeoJSON.encode(feat)
    end
  end

  def latitude(round=3)
    location.latitude.round(round)
  end

  def longitude(round=3)
    location.longitude.round(round)
  end

  def ending
    unless proposed
      return retrieval.recovered rescue nil
    else
      return proposed_ending
    end
  end

  def self.get_deployed_time(row, utc, local, zone)
    # Ugly that the deployment date can be in multiple time zones.
    deployed_time = ""
    # Support OTN
    if row[utc]
      deployed_time = Time.parse(row[utc] + " UTC")
    # Support GLATOS
    else
      tz = row[zone].downcase
      glatos_time = Time.parse(row[local])
      if tz == 'central'
        deployed_time = glatos_time.in_time_zone("America/Chicago").utc
      elsif tz == 'eastern'
        deployed_time = glatos_time.in_time_zone("America/New_York").utc
      else
        errors << "No TIMEZONE specified, assuming 'America/New_York'"
        deployed_time = glatos_time.in_time_zone("America/New_York").utc
      end
    end
    return deployed_time
  end

  def self.load_data(file, otns = [])
    require 'csv'
    deps = []
    errors = []
    count = 0
    fac = RGeo::WKRep::WKTParser.new()
    CSV.foreach(file, {:headers => true}) do |row|
      count += 1
      begin
        otna = OtnArray.find_by_code(row["GLATOS_ARRAY"]) || otns.find{|o|o.code==row["GLATOS_ARRAY"]}
        unless otna
          errors << "Error loading Deployment - No OtnArray with the code #{row["GLATOS_ARRAY"]} - Data: #{row}"
          next
        end

        loc_string = "POINT(#{row['DEPLOY_LONG']} #{row['DEPLOY_LAT']})"
        begin
          fac.parse(loc_string)
        rescue
          errors << "Error loading Location - Lon: #{row['DEPLOY_LONG']}, Lat: #{row['DEPLOY_LAT']} - Data: #{row}"
          next
        end

        d = Deployment.find_or_initialize_by_otn_array_id_and_station_and_consecutive(otna.id, row["STATION_NO"].to_i, row["CONSECUTIVE_DEPLOY_NO"].to_i)
        d.attributes =
          {
            :start => Deployment.get_deployed_time(row, "DEPLOY_DATE_TIME", "GLATOS_DEPLOY_DATE_TIME", "GLATOS_TIMEZONE"),
            :study_id => Study.find_by_code(row["GLATOS_PROJECT"]).id,
            :location => loc_string,
            :model => row["INS_MODEL_NO"],
            :seasonal => row["GLATOS_SEASONAL"].downcase == "yes",
            :frequency => row["GLATOS_INS_FREQUENCY"].to_i,
            :riser_length => row["RISER_LENGTH"].to_i,
            :bottom_depth => row["BOTTOM_DEPTH"].to_i,
            :instrument_depth => row["INSTRUMENT_DEPTH"].to_i,
            :instrument_serial => row["INS_SERIAL_NO"],
            :rcv_modem_address => row["RCV_MODEM_ADDRESS"].to_i,
            :deployed_by => row["DEPLOYED_BY"],
            :vps => row["GLATOS_VPS"].downcase == "yes",
            :funded => true,
            :proposed => false,
            :proposed_ending => nil
          }

        if d.valid?
          deps << d
        else
          errors << "#{d.errors.full_messages.join(" and ")} - Data: #{row}"
        end
      rescue
        errors << "Error loading Deployment - Data: #{row}"
      end
    end
    return deps, errors, count
  end

  def self.load_proposed_data(file)
    require 'csv'
    props = []
    errors = []
    count = 0
    fac = RGeo::WKRep::WKTParser.new()
    CSV.foreach(file, {:headers => true}) do |row|
      count += 1
      begin
        otna = OtnArray.find_by_code(row["GLATOS_ARRAY"])
        unless otna
          errors << "Error loading Deployment - No OtnArray with the code #{row["GLATOS_ARRAY"]} - Data: #{row}"
          next
        end

        loc_string = "POINT(#{row['PROPOSED_LONG']} #{row['PROPOSED_LAT']})"
        begin
          fac.parse(loc_string)
        rescue
          errors << "Error loading Location - Lon: #{row['PROPOSED_LONG']}, Lat: #{row['PROPOSED_LAT']} - Data: #{row}"
          next
        end

        d = Deployment.find_or_initialize_by_otn_array_id_and_station_and_proposed(otna.id, row["STATION_NO"].to_i, true)
        d.attributes =
          {
            :consecutive => nil,
            :proposed_ending => Time.parse(row["PROPOSED_END_DATE"] + "T00:00:00 UTC"),
            :funded => row["GLATOS_FUNDED"].downcase == "yes",
            :start => Time.parse(row["PROPOSED_START_DATE"] + "T00:00:00 UTC"),
            :study_id => Study.find_by_code(row["GLATOS_PROJECT"]).id,
            :location => loc_string,
            :seasonal => row["GLATOS_SEASONAL"].downcase == "yes",
            :frequency => row["GLATOS_INS_FREQUENCY"].to_i,
            :bottom_depth => row["BOTTOM_DEPTH"].to_i,
            :vps => row["GLATOS_VPS"].downcase == "yes"
          }
        if d.valid?
          props << d
        else
          errors << "#{d.errors.full_messages.join(" and ")} - Data: #{row}"
        end
      rescue
        errors << "Error loading Proposed Deployment - Data: #{row}"
      end
    end
    return props, errors, count
  end
end

#
# == Schema Information
#
# Table name: deployments
#
#  id                :integer         not null, primary key
#  start             :datetime
#  study_id          :integer
#  location          :spatial({:srid= indexed
#  otn_array_id      :integer
#  station           :integer
#  model             :string(255)
#  seasonal          :boolean
#  frequency         :integer
#  riser_length      :integer
#  bottom_depth      :integer
#  instrument_depth  :integer
#  instrument_serial :string(255)
#  rcv_modem_address :integer
#  deployed_by       :string(255)
#  vps               :boolean
#  consecutive       :integer
#
