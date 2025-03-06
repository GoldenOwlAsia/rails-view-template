module DateTimeHelper
  def display_date(datetime = Date.current, format = :dmy_slash)
    format_datetime_string(datetime, format, :date)
  end

  def display_time(datetime = Time.zone.now, format = :hm24)
    format_datetime_string(datetime, format, :time)
  end

  def display_datetime(datetime = Time.zone.now, format = :dmy_hm24)
    format_datetime_string(datetime, format, :datetime)
  end

  private

  def format_datetime_string(datetime, format, type)
    return '' if datetime.nil?

    format_string = datetime_formats[type][format] || datetime_formats[type].values.first
    datetime.strftime(format_string)
  end

  def datetime_formats
    {
      date: {
        dmy_dashed: '%Y-%m-%d',
        dmy_slash: '%d/%m/%Y',
        dBy: '%d %B %Y',
        dby: '%d %b %Y'
      },
      time: {
        hm24: '%H:%M',
        hm12: '%I:%M %p',
        hms24: '%H:%M:%S',
        hms12: '%I:%M:%S %p'
      },
      datetime: {
        dmy_hm24: '%d/%m/%Y %H:%M',
        dmy_hm12: '%d/%m/%Y %I:%M %p',
        dmy_hms24: '%d/%m/%Y %H:%M:%S',
        dmy_hms12: '%d/%m/%Y %I:%M:%S %p'
      }
    }
  end
end
