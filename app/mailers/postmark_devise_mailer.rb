class PostmarkDeviseMailer < Devise::Mailer
  FROM_EMAIL = Rails.application.secrets.postmark[:from]
  TEMPLATE_IDS = Rails.application.secrets.postmark[:template_ids]
  CLIENT = Postmark::ApiClient.new(Rails.application.secrets.postmark[:api_key])

  def reset_password_instructions(record, token, _)
    case record
    when User
      params = {
        reset_password_token: token
      }
      url = "#{Rails.application.secrets.host}/#/users/reset_password#{params.to_query}"
    when Admin
      url = edit_admin_password_url(record, reset_password_token: token)
    end

    CLIENT.deliver_with_template(
      from: FROM_EMAIL,
      to: record.email,
      template_id: TEMPLATE_IDS[:reset_password],
      template_model: {
        subject: I18n.t(:subject, scope: 'devise.mailer.reset_password_instructions'),
        name: record.name,
        reset_password_url: url
      }
    )
  end
end
