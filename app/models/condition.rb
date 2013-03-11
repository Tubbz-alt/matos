class Condition < ActiveRecord::Base

  belongs_to :hit

end

# ## Schema Information
# Schema version: 20130311180440
#
# Table name: conditions
#
# Field       | Type               | Attributes
# ----------- | ------------------ | -------------------------
# **id     ** | `integer         ` | `not null, primary key`
# **value  ** | `decimal(12, 4)  ` | ``
# **unit   ** | `string(255)     ` | ``
# **name   ** | `string(255)     ` | ``
# **hit_id ** | `integer         ` | ``
#

