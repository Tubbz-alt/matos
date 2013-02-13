class TagDeployment < ActiveRecord::Base
  include PgSearch

  pg_search_scope :search_all,
                  :against =>  [ :common_name,
                                 :scientific_name,
                                 :capture_location,
                                 :external_codes,
                                 :description,
                                 :release_group,
                                 :release_location
                               ],
                  :using => {
                    :tsearch => {:prefix => true},
                    :trigram => {}
                  }

  pg_search_scope :exact_match,
                  :against => [:external_codes],
                  :using => {
                    :tsearch => {:any_word => true}
                  }

  belongs_to :tag
  belongs_to :study

  has_one    :report
  has_many   :deployments, :through => :hits

  validates :tag_id, :release_date, :presence => true

  validates_inclusion_of :common_name, :in => Fish::TYPES
  #validates_inclusion_of :scientific_name, :in => Fish::SCITYPES
  #validates_inclusion_of :wild_or_hatchery, :in => Fish::WOH
  #validates_inclusion_of :sex, :in => Fish::SEX

  after_create  :set_active_deployment
  after_destroy :set_active_deployment

  set_rgeo_factory_for_column(:capture_geo, RGeo::Geographic.spherical_factory(:srid => 4326))
  set_rgeo_factory_for_column(:surgery_geo, RGeo::Geographic.spherical_factory(:srid => 4326))
  set_rgeo_factory_for_column(:release_geo, RGeo::Geographic.spherical_factory(:srid => 4326))

  def self.find_match(codes)
    TagDeployment.select(:external_codes).each do |ext|
      # If the intersection is not empty, we matched one...
      if !(ext.external_codes & codes).empty?
        return ext
        break
      end
    end
    return nil
  end

  def external_codes
    read_attribute(:external_codes).split(",") rescue nil
  end

  def external_codes=(codes)
    if codes.is_a? String
      write_attribute(:external_codes, codes)
    elsif codes.is_a? Array
      write_attribute(:external_codes, codes.join(","))
    end
  end

  def starting
    release_date
  end

  def ending
    capture_date
  end

  private
    def set_active_deployment
      self.tag.active_deployment = TagDeployment.includes(:tag).where(:tag_id => self.tag.id).order("release_date DESC").limit(1).first
      self.tag.save!
    end
end
#
# == Schema Information
#
# Table name: tag_deployments
#
#  id                                        :integer         not null, primary key
#  tag_id                                    :integer         indexed
#  tagger                                    :string(255)
#  common_name                               :string(255)
#  scientific_name                           :string(255)
#  capture_location                          :string(255)
#  capture_geo                               :spatial({:srid= indexed
#  capture_date                              :datetime
#  capture_depth                             :decimal(6, 2)
#  wild_or_hatchery                          :string(255)
#  stock                                     :string(255)
#  length                                    :decimal(6, 2)
#  weight                                    :decimal(6, 2)
#  age                                       :decimal(5, 2)
#  sex                                       :string(255)
#  dna_sample_taken                          :boolean
#  treatment_type                            :string(255)
#  temperature_change                        :decimal(4, 2)
#  holding_temperature                       :decimal(4, 2)
#  surgery_location                          :string(255)
#  surgery_geo                               :spatial({:srid= indexed
#  surgery_date                              :datetime
#  sedative                                  :string(255)
#  sedative_concentration                    :string(255)
#  anaesthetic                               :string(255)
#  buffer                                    :string(255)
#  anaesthetic_concentration                 :string(255)
#  buffer_concentration_in_anaesthetic       :string(255)
#  anesthetic_concentration_in_recirculation :string(255)
#  buffer_concentration_in_recirculation     :string(255)
#  do                                        :integer
#  description                               :text
#  release_group                             :string(255)
#  release_location                          :string(255)
#  release_geo                               :spatial({:srid= indexed
#  release_date                              :datetime
#  external_codes                            :string(255)
#  length_type                               :string(255)
#  implant_type                              :string(255)
#
