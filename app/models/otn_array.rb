class OtnArray < ActiveRecord::Base

  has_many :receiver_deployments

  validates_presence_of :code

  def to_label
    title
  end

  def title
    "#{self.code} - #{self.description}"
  end

end

# ## Schema Information
# Schema version: 20130311180440
#
# Table name: otn_arrays
#
# Field            | Type               | Attributes
# ---------------- | ------------------ | -------------------------
# **id          ** | `integer         ` | `not null, primary key`
# **code        ** | `string(255)     ` | ``
# **description ** | `text            ` | ``
# **waterbody   ** | `string(255)     ` | ``
# **region      ** | `string(255)     ` | ``
#
# Indexes
#
#  index_otn_arrays_on_code  (code)
#

