class SubmissionMailer < ActionMailer::Base

  def new_submission(submission)
    @submission = submission
    recips = @submission.user.email
    bccs = User.where("role = 'admin'").map(&:email)
    mail(:to => recips, :bcc => bccs, :subject => "[#{I18n.t :project_name}] Data Submission Received")
  end

end
