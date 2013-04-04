class Hit < ActiveRecord::Base

  belongs_to :receiver_deployment
  belongs_to :tag_deployment
  has_many :conditions, :dependent => :destroy

  set_rgeo_factory_for_column(:location, RGeo::Geographic.spherical_factory(:srid => 4326, :has_z_coordinate => true, :has_m_coordinate => true))

end

# ## Schema Information
# Schema version: 20130404154754
#
# Table name: hits
#
# Field                       | Type               | Attributes
# --------------------------- | ------------------ | -------------------------
# **id                     ** | `integer         ` | `not null, primary key`
# **receiver_deployment_id ** | `integer         ` | ``
# **receiver_code          ** | `string(255)     ` | ``
# **tag_deployment_id      ** | `integer         ` | ``
# **tag_code               ** | `string(255)     ` | ``
# **time                   ** | `datetime        ` | ``
# **depth                  ** | `decimal(8, 4)   ` | ``
# **location               ** | `spatial({:srid=>` | ``
# **created_at             ** | `datetime        ` | ``
#

