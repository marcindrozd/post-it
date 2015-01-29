module ApplicationHelper
  def updated_url(url)
    url.start_with?("http") ? url : "http://#{url}"
  end

  def format_date(date)
    date.strftime("%d-%b-%Y %H:%M")
  end
end
