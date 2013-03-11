class Submission < ActiveRecord::Base

  belongs_to :user

  before_destroy :destroy_extracted

  validates_presence_of :user

  has_attached_file :zipfile
  validates_attachment_presence :zipfile
  validates_attachment_content_type :zipfile, :content_type => /^application\/(x-zip-compressed|zip)$/, :message => 'is not a ZIP file'

  def DT_RowId
    self.id
  end

  def zipfile_url
    self.zipfile.url
  end

  def status=(status)
    write_attribute(:status,status.downcase)
  end

  def extract
    Zip::ZipFile.open(self.zipfile.path) do |zip|
      zip.each do |entry|
        zip.extract(entry, "#{File.dirname(self.zipfile.path)}/#{entry.name}")
      end
    end

  end

  def destroy_extracted
    FileUtils.rm_f(self.csvfiles)
    FileUtils.rm_f(self.xlsmfiles)
  end

  def csvfiles
    return Dir[File.dirname(Rails.root + self.zipfile.path) + "/*.csv"]
  end

  def xlsmfiles
    return Dir[File.dirname(Rails.root + self.zipfile.path) + "/*.xlsm"]
  end
end

# ## Schema Information
# Schema version: 20130311180440
#
# Table name: submissions
#
# Field                     | Type               | Attributes
# ------------------------- | ------------------ | -------------------------
# **id                   ** | `integer         ` | `not null, primary key`
# **user_id              ** | `integer         ` | ``
# **zipfile_file_name    ** | `string(255)     ` | ``
# **zipfile_content_type ** | `string(255)     ` | ``
# **zipfile_file_size    ** | `integer         ` | ``
# **zipfile_updated_at   ** | `datetime        ` | ``
# **status               ** | `string(255)     ` | ``
# **created_at           ** | `datetime        ` | `not null`
# **updated_at           ** | `datetime        ` | `not null`
#

