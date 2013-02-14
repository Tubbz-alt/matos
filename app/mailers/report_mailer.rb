class ReportMailer < ActionMailer::Base

  def report_invoice(report)
    @report = report
    recips = @report.email
    mail(:to => recips, :subject => "[#{I18n.t 'project.name'}] Report Confirmation")
  end

  def unmatched_report_notification(report)
    @report = report
    recips = User.where("role = 'admin'").map(&:email)
    mail(:to => recips, :subject => "[#{I18n.t 'project.name'}] Unmatched Tag Report Submitted")
  end

  def matched_report_notification(report)
    @report = report
    recips = @report.tag_deployment.study.user.email
    ccs = User.where("role = 'admin'").map(&:email)
    mail(:to => recips, :cc => ccs, :subject => "[#{I18n.t 'project.name'}] Tag Report Submitted")
  end

end
