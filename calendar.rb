$LOAD_PATH << "lib"
require "active_support"
require "holidays"
require "icalendar"

require "sinatra"

get "/" do
  erb :index
end

get "/:province.ics" do
  cal = Icalendar::Calendar.new

  Holidays.between(8.months.ago, 66.months.from_now, :"ca_#{params[:province].downcase}").each do |holiday|
    cal.event do |e|
      e.dtstart = Icalendar::Values::Date.new(holiday[:date])
      e.dtend = Icalendar::Values::Date.new(holiday[:date])
      e.summary = holiday[:name]
    end
  end
  cal.publish

  content_type "text/calendar"
  cal.to_ical
end

__END__

@@ index

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <title>Provincial Stat Holidays</title>
  <link rel="stylesheet" href="http://twitter.github.com/bootstrap/1.3.0/bootstrap.min.css">
</head>
<body>
  <div class="content">
    <div class="row">
      <div class="span2">&nbsp;</div>
      <div class="span8">
        <h3>Canadian Provincial Statutory Holidays</h3>
        <p>In iCal format! Subscribe in your calendar reader for the current year and next 5 years, automatically updating.</p>
        <ul>
          <li><a href="/BC.ics">British Columbia</a></li>
          <li><a href="/AB.ics">Alberta</a></li>
          <li><a href="/SK.ics">Saskatchewan</a></li>
          <li><a href="/MB.ics">Manitoba</a></li>
          <li><a href="/ON.ics">Ontario</a></li>
          <li><a href="/QC.ics">Quebec</a></li>
          <li><a href="/NB.ics">New Brunswick</a></li>
          <li><a href="/NS.ics">Nova Scotia</a></li>
          <li><a href="/PE.ics">Prince Edward Island</a></li>
          <li><a href="/NL.ics">Newfoundland</a></li>
          <li><a href="/YT.ics">Youkon Territory</a></li>
          <li><a href="/NT.ics">Northwest Territories</a></li>
          <li><a href="/NU.ics">Nunavut</a></li>
        </ul>

        <p>Data via Ruby <a href="https://github.com/holidays/holidays/">Holidays gem</a></p>
      </div>
    </div>
  </div>
</body>
</html>

