class StudyObserver < ActiveRecord::Observer

  def after_create(study)
    # An admin needs to approve new studies
    StudyMailer.new_study(study).deliver

    # Create a default OTN Array for this study
    OtnArray.create(:code => study.code, :description => study.title)
  end

  def after_save(study)
    # Let the study's creater know their study was approved
    if study.approved_changed? && study.approved_was == false && study.approved == true
      StudyMailer.study_approved(study).deliver
    end
  end

  def after_destroy(study)
    OtnArray.find_by_code(study.code).destroy_all rescue true
  end

end
