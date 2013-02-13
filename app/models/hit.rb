class Hit < ActiveRecord::Base

  belongs_to :deployment
  belongs_to :tag_deployment
  has_many :conditions

  set_rgeo_factory_for_column(:location, RGeo::Geographic.spherical_factory(:srid => 4326, :has_z_coordinate => true, :has_m_coordinate => true))

  def DT_RowId
    self.id
  end

end