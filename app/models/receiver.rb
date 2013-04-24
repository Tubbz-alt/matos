class Receiver < ActiveRecord::Base
  include PgSearch

  pg_search_scope :search_all,
                  :against => [:model, :serial],
                  :using => {
                    :tsearch => {:prefix => true},
                    :trigram => {}
                  }

  has_many :receiver_deployments, :dependent => :destroy

  validates_presence_of :model, :serial

  def model=(model)
    write_attribute(:model,model.downcase)
  end

  def serial=(serial)
    write_attribute(:serial,serial.downcase)
  end

  def rcv_modem_address
    "%03d" % read_attribute(:rcv_modem_address) rescue nil
  end

  def geo_attributes
    removals = %w(id)
    s = self.attributes.delete_if {|k,v| removals.include?(k) }
    return s
  end

end

# ## Schema Information
# Schema version: 20130404154754
#
# Table name: receivers
#
# Field                  | Type               | Attributes
# ---------------------- | ------------------ | -------------------------
# **id                ** | `integer         ` | `not null, primary key`
# **model             ** | `string(255)     ` | ``
# **frequency         ** | `integer         ` | ``
# **serial            ** | `string(255)     ` | ``
# **rcv_modem_address ** | `integer         ` | ``
# **vps               ** | `boolean         ` | ``
#

