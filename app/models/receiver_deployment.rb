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

  validates_presence_of :study_id, :otn_array_id, :location, :receiver_id

  validates_presence_of :station, :if => "name.nil? || name.blank?"
  validates_presence_of :name,    :if => "station.nil? || station.blank?"

  set_rgeo_factory_for_column(:location, RGeo::Geographic.spherical_factory(:srid => 4326))

  scope :active_study, joins(:study).where('studies.title IS NOT NULL AND studies.name IS NOT NULL AND studies.start IS NOT NULL and studies.ending IS NOT NULL')

  scope :readable, lambda {|u| 
    if u.is_admin?
      includes({ :study => {:collaborators => :user}})
    else
      includes({ :study => {:collaborators => :user}}).where("studies.user_id = #{u.id} OR users.id = #{u.id}")
    end
  }
  scope :managable, lambda {|u|
    if u.is_admin?
      includes({ :study => {:collaborators => :user}})
    else
      includes({ :study => {:collaborators => :user}}).where("studies.user_id = #{u.id} OR ( collaborators.role = 'manage' AND users.id = #{u.id} )")
    end
  }
  def station
    "%03d" % read_attribute(:station) rescue nil
  end

  def code
    r = []
    r << otn_array.code if otn_array
    r << station if station
    r << consecutive if consecutive
    r << name if name
    return r.join("-")
  end

  def geo
    return RGeo::GeoJSON.encode(self.location)
  end

  def geo_attributes
    s = {}
    s[:code]      = code
    s[:start]     = start
    s[:ending]    = ending
    s[:seasonal]  = seasonal
    s[:proposed]  = proposed
    s[:otn_array] = { :code => otn_array.code, :description => otn_array.description, :waterbody => otn_array.waterbody, :region => otn_array.region }
    s[:receiver]  = { :model => receiver.model, :serial => receiver.serial, :frequency => receiver.frequency, :vps => receiver.vps, :rcv_modem_address => receiver.rcv_modem_address }
    s[:study]  = { :id => study.id, :name => study.name, :description => study.description }
    return s
  end

  def geojson
    if self.location
      s = self.geo_attributes
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
    return proposed_ending if proposed and !proposed_ending.nil?
    return recovery_date unless recovery_date.nil?
    return nil
  end

  def display_name
    "#{code}"
  end

  def to_label
    "#{code}"
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

