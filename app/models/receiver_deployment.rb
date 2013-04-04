class ReceiverDeployment < ActiveRecord::Base

  require 'rgeo/geo_json'
  include PgSearch

  pg_search_scope :search_all,
                  :against => [:name, :station],
                  :using => {
                    :tsearch => {:prefix => true},
                    :trigram => {}
                  },
                  :associated_against => {
                    :otn_array => [ :code,
                                    :description,
                                    :waterbody
                                  ],
                    :receiver => [:model, :serial]
                  }

  belongs_to :study
  belongs_to :otn_array
  belongs_to :receiver
  has_many :hits
  has_many :tag_deployments, :through => :hits

  validates_presence_of :study_id, :otn_array_id, :station, :location, :receiver_id

  set_rgeo_factory_for_column(:location, RGeo::Geographic.spherical_factory(:srid => 4326, :has_z_coordinate => true, :has_m_coordinate => true))

  scope :active_study, joins(:study).where('studies.title IS NOT NULL AND studies.name IS NOT NULL AND studies.start IS NOT NULL and studies.ending IS NOT NULL')

  scope :readable, lambda {|u| includes({ :study => {:collaborators => :user}}).where("users.role = 'admin' OR studies.user_id = #{u.id} OR users.id = #{u.id}") }
  scope :managable, lambda {|u| includes({ :study => {:collaborators => :user}}).where("users.role = 'admin' OR studies.user_id = #{u.id} OR ( collaborators.role = 'manage' AND users.id = #{u.id} )") }

  def station
    "%03d" % read_attribute(:station) rescue nil
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
    return proposed_ending if proposed
    return recovery_date unless recovery_date.nil?
    return nil
  end

  def display_name
    "#{code}-#{consecutive}"
  end

  def to_label
    "#{code}-#{consecutive}"
  end

end

# ## Schema Information
# Schema version: 20130404154754
#
# Table name: receiver_deployments
#
# Field                  | Type               | Attributes
# ---------------------- | ------------------ | -------------------------
# **id                ** | `integer         ` | `not null, primary key`
# **receiver_id       ** | `integer         ` | ``
# **location          ** | `spatial({:srid=>` | ``
# **start             ** | `datetime        ` | ``
# **study_id          ** | `integer         ` | ``
# **otn_array_id      ** | `integer         ` | ``
# **name              ** | `string(255)     ` | ``
# **station           ** | `integer         ` | ``
# **seasonal          ** | `boolean         ` | ``
# **riser_length      ** | `decimal(8, 2)   ` | ``
# **bottom_depth      ** | `decimal(8, 2)   ` | ``
# **instrument_depth  ** | `decimal(8, 2)   ` | ``
# **funded            ** | `boolean         ` | ``
# **proposed          ** | `boolean         ` | ``
# **proposed_ending   ** | `datetime        ` | ``
# **consecutive       ** | `integer         ` | ``
# **deployed_by       ** | `string(255)     ` | ``
# **recovery_date     ** | `datetime        ` | ``
# **recovery_location ** | `spatial({:srid=>` | ``
# **data_downloaded   ** | `boolean         ` | ``
# **ar_confirm        ** | `boolean         ` | ``
#
# Indexes
#
#  index_receiver_deployments_on_receiver_id  (receiver_id)
#  index_receiver_deployments_on_study_id     (study_id)
#

