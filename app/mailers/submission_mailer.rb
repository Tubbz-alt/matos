class SubmissionMailer < ActionMailer::Base

  default :from => "matos@asascience.com"

  def new_submission(submission)
    @submission = submission
    recips = @submission.user.email
    bccs = User.where("role = 'admin'").map(&:email)
    mail(:to => recips, :bcc => bccs, :subject => "[#{I18n.t 'project.name'}] Data Submission Received")
  end

end
