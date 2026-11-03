module DateTimeHelper
  FORMAT_DATE = {
    dmy_dashed: '%Y-%m-%d',
    dmy_slash: '%d/%m/%Y',
    dBy: '%d %B %Y',
    dby: '%d %b %Y'
  }.freeze

  FORMAT_TIME = {
    hm24: '%H:%M',
    hm12: '%I:%M',
    hms24: '%H:%M:%S',
    hms12: '%I:%M:%S'
  }.freeze

  FORMAT_DATETIME = {
    dmy_hm24: '%d/%m/%Y %H:%M',
    dmy_hm12: '%d/%m/%Y %I:%M',
    dmy_hms24: '%d/%m/%Y %H:%M:%S',
    dmy_hms12: '%d/%m/%Y %I:%M:%S'
  }.freeze

  def display_date(datetime = Date.current, format = nil)
    strtime = FORMAT_DATE[format] || '%d/%m/%Y'
    datetime.strftime(strtime)
  end

  def display_time(datetime = DateTime.current, format = nil)
    strtime = FORMAT_TIME[format] || '%H:%M'
    datetime.strftime(strtime)
  end

  def display_datetime(datetime = DateTime.current, format = nil)
    strtime = FORMAT_DATETIME[format] || '%d/%m/%Y %H:%M'
    datetime.strftime(strtime)
  end
end
