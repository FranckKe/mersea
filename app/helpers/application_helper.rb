module ApplicationHelper
  def bulma_flash_message(status)
    case status
    when 'alert'
      'is-danger'
    when 'notice'
      'is-info'
    else
      ''
    end
  end
end
