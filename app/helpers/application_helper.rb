module ApplicationHelper
  # Простая пагинация
  def paginate(collection, per_page = 10)
    page = params[:page]&.to_i || 1
    offset = (page - 1) * per_page
    collection.limit(per_page).offset(offset)
  end

  # Форматирование даты
  def format_date(date)
    date&.strftime("%d.%m.%Y %H:%M")
  end

  # Обрезка текста
  def truncate_text(text, length = 50)
    truncate(text, length: length, omission: "...")
  end

  # Бейдж для статуса
  def status_badge(status)
    case status
    when 'active', 'completed'
      content_tag :span, status.humanize, class: 'badge badge-success'
    when 'pending', 'not_started'
      content_tag :span, status.humanize, class: 'badge badge-warning'
    when 'inactive', 'dropped'
      content_tag :span, status.humanize, class: 'badge badge-secondary'
    else
      content_tag :span, status.humanize, class: 'badge'
    end
  end
end