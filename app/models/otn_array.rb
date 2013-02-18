class OtnArray < ActiveRecord::Base

  has_many :deployments

  validates_presence_of :code

  def self.load_data(file)
    require 'csv'
    otns = []
    errors = []
    count = 0
    CSV.foreach(file, {:headers => true}) do |row|
      count += 1
      o = OtnArray.find_or_initialize_by_code(row['GLATOS_ARRAY'])
      o.attributes =
        {
          :description => row["LOCATION_DESCRIPTION"],
          :waterbody => row["WATER_BODY"],
          :region => row["GLATOS_REGION"]
        }
      if o.valid?
        otns << o
      else
        errors << "#{o.errors.full_messages.join(" and ")} - Data: #{row}"
      end
    end
    return otns, errors, count
  end

  def to_label
    title
  end

  def title
    "#{self.code} - #{self.description}"
  end

end
#
# == Schema Information
#
# Table name: otn_arrays
#
#  id          :integer         not null, primary key
#  code        :string(255)     indexed
#  description :text
#  waterbody   :string(255)
#  region      :string(255)
#
