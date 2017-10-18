class ScheduleMailer < ApplicationMailer

  default from: 'admin@scheduler.com'
  layout "mailer"

  def create_schedule(scheduler, user)
    mail(
        to: user.email,
        subject: " Assigned you a Schedule "
    )
  end

  def schedule_change_request(recipients,date,user)
      @schedule_request = date
      @user = user
  	mail(
  		to: recipients.map(&:email).uniq,
  		subject: "Schedule Change Request")
  end

  def schedule_request_accepted(user)
    mail(
        to: user.email,
        subject: "Schedule Change Request Accepted"
    )
  end

  def schedule_request_rejected(user)
    mail(
        to: user.email,
        subject: "Schedule Change Request Rejected"
    )
  end


end
