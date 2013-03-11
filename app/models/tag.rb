class Tag < ActiveRecord::Base
  include PgSearch

  pg_search_scope :search_all,
                  :against => [:serial, :code, :code_space, :model, :manufacturer, :description],
                  :using => {
                    :tsearch => {:prefix => true},
                    :trigram => {}
                  }

  pg_search_scope :exact_match,
                  :against => [:serial, :code, :code_space],
                  :using => {
                    :tsearch => {:any_word => true}
                  }

  has_many   :tag_deployments, :dependent => :destroy, :order => "release_date DESC"
  belongs_to :active_deployment, :class_name => TagDeployment

  validates_uniqueness_of   :code, :scope => :code_space, :case_sensitive => false

  validates_presence_of     :code, :code_space

  self.inheritance_column = 'none'

  scope :find_match, lambda { |code| where("((code_space || '-' || code) ILIKE ?) OR (code ILIKE ?) OR (code_space ILIKE ?)", "%#{code}%","%#{code}%","%#{code}%").limit(1) }
  scope :find_all_matches, lambda { |code| where("((code_space || '-' || code) ILIKE ?) OR (code ILIKE ?) OR (code_space ILIKE ?)", "%#{code}%","%#{code}%","%#{code}%") }

  def active_deployment_json
    begin
      return active_deployment.as_json({
        :include => {
          :study => {
            :only => [:id, :name],
            :include => {:user => {
              :only => [:name, :email]
            }}
          }
        },
        :only => [:release_date, :release_location, :external_codes, :length, :weight, :age, :sex, :common_name]
      })
    rescue
      return TagDeployment.new.as_json({:only => [:release_date, :release_location, :external_codes, :length, :weight, :age, :sex, :common_name]})
    end
  end

  def self.load_tag_deployments(file = "#{Rails.root}/lib/data/old/tag.csv")
    require 'csv'
    tag_deployments = []
    errors = []
    count = 0
    CSV.foreach(file, {:headers => true}) do |row|
      count += 1
      begin
        begin
          deployed_time = Deployment.get_deployed_time(row,"UTC_RELEASE_DATE_TIME", "GLATOS_RELEASE_DATE_TIME", "GLATOS_TIMEZONE")
        rescue
          errors << "Error loading Tag - No RELEASE_DATE specified  Data: #{row}"
          next
        end
        woh_d = row["WILD_OR_HATCHERY"].downcase rescue ""
        woh = woh_d == "w" ? "Wild" : woh_d == "h" ? "Hatchery" : "Unknown"

        t = Tag.find_by_code_and_code_space(row["TAG_ID_CODE"], row["TAG_CODE_SPACE"])
        if t.nil?
          errors << "Error finding Tag for Tagdeployment - No match on the code and code_space - Data: #{row}"
          next
        end

        td = TagDeployment.find_or_initialize_by_tag_id_and_release_date(t.id, deployed_time)

        td.attributes =
          {
            :study => Study.find_by_code(row["GLATOS_PROJECT"]),
            :tagger => row["TAGGER"],
            :common_name => Fish::TYPES.select{|s| /#{Regexp.escape(row["COMMON_NAME_E"].humanize)}/i.match(s)}.first,
            :scientific_name => Fish::SCITYPES.select{|s| /#{Regexp.escape(row["SCIENTIFIC_NAME"].humanize)}/i.match(s)}.first,
            :capture_location => row["CAPTURE_LOCATION"],
            :capture_geo => "POINT(#{row['CAPTURE_LONGITUDE']} #{row['CAPTURE_LATITUDE']})",
            :capture_depth => Tag.decimal_or_nil(row["CAPTURE_DEPTH"]),
            :capture_date => Tag.time_or_nil("#{row["GLATOS_CAUGHT_DATE"]}T00:00:00 UTC"),
            :wild_or_hatchery => woh,
            :stock => row["STOCK"],
            :dna_sample_taken => Tag.boolean_or_nil(row["DNA_SAMPLE_TAKEN"]),
            :treatment_type => row["TREATMENT_TYPE"],
            :temperature_change => Tag.decimal_or_nil(row["TEMPERATURE_CHANGE"]),
            :holding_temperature => Tag.decimal_or_nil(row["HOLDING_TEMPERATURE"]),
            :surgery_location => row["SURGERY_LOCATION"],
            :surgery_geo => "POINT(#{row['SURGERY_LONGITUDE']} #{row['SURGERY_LATITUDE']})",
            :surgery_date => Tag.time_or_nil("#{row["DATE_OF_SURGERY"]}T00:00:00 UTC"),
            :sedative => row["SEDATIVE"],
            :sedative_concentration => row["SEDATIVE_CONCENTRATION"],
            :anaesthetic => row["ANAESTHETIC"],
            :buffer => row["BUFFER"],
            :anaesthetic_concentration => row["ANAESTHETIC_CONCENTRATION"],
            :buffer_concentration_in_anaesthetic => row["BUFFER_CONCENTRATION_IN_ANAESTHETIC"],
            :anesthetic_concentration_in_recirculation => row["ANESTHETIC_CONCENTRATION_IN_RECIRCULATION"],
            :buffer_concentration_in_recirculation => row["BUFFER_CONCENTRATION_IN_RECIRCULATION"],
            :do => Tag.decimal_or_nil(row["DISSOLVED_OXYGEN"]),
            :description => row["COMMENTS"],
            :release_group => row["RELEASE_GROUP"],
            :release_location => row["RELEASE_LOCATION"],
            :release_geo => "POINT(#{row['RELEASE_LONGITUDE']} #{row['RELEASE_LATITUDE']})",
            :external_codes => [row["GLATOS_EXTERNAL_TAG_ID1"], row["GLATOS_EXTERNAL_TAG_ID2"]].compact.uniq,
            :sex => row["SEX"],
            :age => row["AGE"],
            :weight => Tag.decimal_or_nil(row["WEIGHT"]),
            :length => Tag.decimal_or_nil(row["LENGTH"]),
            :length_type => row["LENGTH_TYPE"],
            :implant_type => row["TAG_IMPLANT_TYPE"],
            :reward => row["GLATOS_REWARD"]
          }
        if td.valid?
          tag_deployments << td
        else
          errors << "#{td.errors.full_messages.join(" and ")} - Data: #{row}"
        end
      rescue Exception => e
        errors << "Error creating TagDeployment - #{e.message} - #{e.backtrace[0..5].join('<br />')} - Data: #{row}"
      end
    end
    return tag_deployments, errors, count
  end

  def self.load_data(file = "#{Rails.root}/lib/data/old/tag.csv")
    require 'csv'
    tags = []
    errors = []
    count = 0
    CSV.foreach(file, {:headers => true}) do |row|
      count += 1
      begin
        begin
          deployed_time = Deployment.get_deployed_time(row,"UTC_RELEASE_DATE_TIME", "GLATOS_RELEASE_DATE_TIME", "GLATOS_TIMEZONE")
        rescue
          errors << "Error loading Tag - No RELEASE_DATE specified  Data: #{row}"
          next
        end
        t = Tag.find_or_initialize_by_code_and_code_space(row["TAG_ID_CODE"], row["TAG_CODE_SPACE"])
        t.attributes =
          {
            :model => row["TAG_MODEL"],
            :manufacturer => row["TAG_MANUFACTURER"],
            :serial => row["TAG_SERIAL_NUMBER"],
            :description => row["COMMENTS"],
            :type => row["TAG_TYPE"],
            :lifespan => ("#{row["EST_TAG_LIFE"].split(" ")[0]} days" rescue nil),
            :endoflife => (deployed_time.advance(:days => row["EST_TAG_LIFE"].split(" ")[0].to_i) rescue nil)
          }
        if t.valid?
          tags << t
        else
          errors << "#{t.errors.full_messages.join(" and ")} - Data: #{row}"
        end
      rescue Exception => e
        errors << "Error loading Tag #{e.backtrace[0..5].join("<br />")} - Data: #{row}"
      end
    end
    return tags, errors, count
  end

  def self.decimal_or_nil(input)
    BigDecimal.new(input) rescue nil
  end
  def self.time_or_nil(input)
    Time.parse(input) rescue nil
  end
  def self.boolean_or_nil(input)
    input.downcase == "yes" rescue nil
  end

  def to_label
    "#{code_space}-#{code}"
  end

  def display_name
    "#{code_space}-#{code}"
  end

end

# ## Schema Information
#
# Table name: `tags`
#
# ### Columns
#
# Name                        | Type               | Attributes
# --------------------------- | ------------------ | ---------------------------
# **`id`**                    | `integer`          | `not null, primary key`
# **`serial`**                | `string(255)`      |
# **`code`**                  | `string(255)`      |
# **`code_space`**            | `string(255)`      |
# **`lifespan`**              | `string(255)`      |
# **`endoflife`**             | `datetime`         |
# **`model`**                 | `string(255)`      |
# **`manufacturer`**          | `string(255)`      |
# **`type`**                  | `string(255)`      |
# **`description`**           | `text`             |
# **`active_deployment_id`**  | `integer`          |
#
# ### Indexes
#
# * `index_tags_on_model`:
#     * **`model`**
#

