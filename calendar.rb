$LOAD_PATH << 'lib'
require 'holidays'

require 'icalendar'

cal = Icalendar::Calendar.new

Holiday.all(2011, ARGV[0] || Holiday.provinces).each do |holiday|
  cal.event do
    dtstart holiday.date
    dtend   holiday.date
    summary holiday.name
  end
end
cal.publish

require 'pp'
puts cal.to_ical
