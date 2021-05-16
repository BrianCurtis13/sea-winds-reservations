def display_report(report_data)
  puts report_data.first.keys.join(', ')
  report_data.each do |line|
    puts line.values.join(', ')
  end
end

def display_tabbed_report(report_data)
  puts report_data.first.keys.join("\t")
  report_data.each do |line|
    puts line.values.join("\t")
  end
end

def output_report_to_csv(report_data, file_handle = "live_migrations")
  filename = "#{file_handle}_report_#{DateTime.now}.csv"
  output = CSV.open(filename, 'w')
  output << report_data.first.keys
  report_data.each do |line|
    output << line.values
  end
  output.close
end

def sort_by_array(hash, array)
  hash.sort_by { |k, _| array.index(k) }.to_h
end

def resource_count_output_preparer(list, default_value = 0)
  Hash[list.collect {|list_item| [list_item, default_value]}]
end

def display_counts(count_hash)
  count_hash.each {|k,v| puts "#{k}, #{v}"}
end

def separator
  puts ""
  puts "* * * * *"
  puts ""
end

def count_report_header(resource, header_name = nil)
  header_name = header_name || resource
  header_name = header_name.capitalize
  puts "Project count by #{resource}"
  puts ""
  puts "#{header_name}, Count"
  puts "----------------------"
end