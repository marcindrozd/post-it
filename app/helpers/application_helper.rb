module ApplicationHelper
  def updated_url(url)
    url.start_with?("http") ? url : "http://#{url}"
  end

  def format_date(date)
    if logged_in? && !current_user.time_zone.nil?
      date = date.in_time_zone(current_user.time_zone)
    end

    date.strftime("%d-%b-%Y %H:%M %Z")
  end
end
