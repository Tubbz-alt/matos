class StudyObserver < ActiveRecord::Observer

  def after_create(study)
    StudyMailer.new_study(study).deliver
  end

  def after_save(study)
    if study.approved_changed? && study.approved_was == false && study.approved == true
      StudyMailer.study_approved(study).deliver
    end
  end
end
