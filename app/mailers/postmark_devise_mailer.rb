class PostmarkDeviseMailer < Devise::Mailer
  FROM_EMAIL = Rails.application.secrets.postmark[:from]
  TEMPLATE_IDS = Rails.application.secrets.postmark[:template_ids]
  CLIENT = Postmark::ApiClient.new(Rails.application.secrets.postmark[:api_key])
  HOST = URI(Rails.application.secrets.host)

  def reset_password_instructions(record, token, _)
    case record
    when User
      uri = URI.join(HOST, '#', 'users', 'reset_password')
      uri.query = {reset_password_token: token}.to_query
      uri.to_s
    when Admin
      uri = edit_admin_password_url(record, reset_password_token: token)
    end

    CLIENT.deliver_with_template(
      from: FROM_EMAIL,
      to: record.email,
      template_id: TEMPLATE_IDS[:reset_password],
      template_model: {
        subject: I18n.t(:subject, scope: 'devise.mailer.reset_password_instructions'),
        name: record.name,
        reset_password_url: uri
      }
    )
  end
end
