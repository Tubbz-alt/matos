class Hit < ActiveRecord::Base

  belongs_to :deployment
  belongs_to :tag_deployment
  has_many :conditions

  set_rgeo_factory_for_column(:location, RGeo::Geographic.spherical_factory(:srid => 4326, :has_z_coordinate => true, :has_m_coordinate => true))

  def DT_RowId
    self.id
  end

end

# ## Schema Information
#
# Table name: `hits`
#
# ### Columns
#
# Name                     | Type               | Attributes
# ------------------------ | ------------------ | ---------------------------
# **`id`**                 | `integer`          | `not null, primary key`
# **`deployment_id`**      | `integer`          |
# **`deployment_code`**    | `string(255)`      |
# **`tag_deployment_id`**  | `integer`          |
# **`tag_code`**           | `string(255)`      |
# **`time`**               | `datetime`         |
# **`depth`**              | `decimal(8, 4)`    |
# **`location`**           | `spatial({:srid=>4326, :type=>"point", :has_z=>true, :has_m=>true, :geographic=>true})`                                                                      |
# **`created_at`**         | `datetime`         |
#

