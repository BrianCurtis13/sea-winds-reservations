def raw_weeks(start_date, end_date)
  days = (Date.parse(start_date.to_s)..Date.parse(end_date.to_s)).to_a
  weeks = ([days.shift(7-days.first.wday)].concat(
            days.each_slice(7).to_a)).map { |w|
              [w.first, w.last].map {|d| [d.year, d.month, d.day, d.wday] }
            }
end

def week_string(week)
  "#{week[0]}/#{week[1]}/#{week[2]}"
end

def weeks_in_time_period(raw_weeks)
  week_number = 0
  raw_weeks.each_with_object([]) do |week, array|
    week_number += 1
    array << { :week_number => week_number, :start => week_string(week[0]), :end => week_string(week[1]) }
  end
end

def average_metric(migration_group, metric, exclude_zeroes: 'false')
  return 0 if migration_group.count == 0
  metric_array = migration_group.map {|m| metric.call(m) }
  metric_array.delete(0) if :exclude_zeroes == 'true'
  metric_array.sum / migration_group.count
end

def median_metric(project_group, metric, exclude_zeroes: 'false')
  return 0 if project_group.count == 0
  metric_array = project_group.map {|m| metric.call(m) }
  metric_array.delete(0) if :exclude_zeroes == 'true'
  sorted = metric_array.sort
  len = sorted.length
  (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
end