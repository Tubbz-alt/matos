class StudyMailer < ActionMailer::Base

  default :from => 'matos@asascience.com'

  def new_study(study)
    @study = study
    recips = User.where("role = 'admin'").map(&:email)
    mail(:to => recips, :subject => "[#{I18n.t 'project.name'}] New Study")
  end

  def study_approved(study)
    @study = study
    recips = study.user.email
    mail(:to => recips, :subject => "[#{I18n.t 'project.name'}] Study Approved")
  end

end
