class Report < ActiveRecord::Base
  include PgSearch

  pg_search_scope :search_all,
                  :against => [ :input_tag, :description, :method, :name, :email, :phone, :city, :state,
                                :fishtype,  :input_external_codes ],
                  :using => {
                    :tsearch => {:prefix => true},
                    :trigram => {}
                  },
                  :associated_against => {
                    :tag_deployment => [  :common_name,
                                          :scientific_name,
                                          :capture_location,
                                          :external_codes,
                                          :description,
                                          :release_group,
                                          :release_location
                                        ]
                  }

  belongs_to  :tag_deployment

  validates :input_tag, :presence => { :if => lambda {|a| a.input_external_codes.blank? }, :message => "You must enter an internal or external tag ID (or both)"}
  validates :method, :name, :fishtype, :didwith, :found, :phone, :address, :city, :state, :zipcode, :presence => true
  validates :email, :format => { :with => /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i, :message => "Invalid Email Address" }

  set_rgeo_factory_for_column(:location, RGeo::Geographic.spherical_factory(:srid => 4326))

  METHODS = ['Caught - Commercial Fishing','Caught - Recreational Fishing','Caught - Tribal Fishing']
  DIDWITH = ['Caught and kept the fish', 'Caught and released the fish']

  before_create { |record| record.reported ||= Time.now.utc }

  def DT_RowId
    self.id
  end

  def input_external_codes
    read_attribute(:input_external_codes).split(",") rescue nil
  end

  def input_external_codes_one
    input_external_codes.first rescue nil
  end

  def input_external_codes_two
    input_external_codes.second rescue nil
  end

  def input_external_codes=(codes)
    if codes.is_a? String
      write_attribute(:input_external_codes, codes)
    elsif codes.is_a? Array
      write_attribute(:input_external_codes, codes.join(","))
    end
  end

end
#
# == Schema Information
#
# Table name: reports
#
#  id                   :integer         not null, primary key
#  input_tag            :string(255)     not null, indexed
#  description          :text
#  method               :string(255)
#  name                 :string(255)
#  phone                :string(255)
#  email                :string(255)
#  city                 :string(255)
#  state                :string(255)
#  reported             :datetime
#  found                :datetime
#  length               :decimal(6, 2)
#  fishtype             :string(255)
#  location             :spatial({:srid= indexed
#  tag_deployment_id    :integer         indexed, indexed
#  contacted            :boolean
#  resolved             :boolean
#  input_external_codes :string(255)
#  address              :string(255)
#  zipcode              :string(8)
#  newsletter           :boolean         default(FALSE)
#  didwith              :string(255)
#  comments             :text
#  depth                :decimal(6, 2)
#

