require 'pry'
require 'pdf-reader'

input_file = ARGV[0]

output_file = ARGV[1]

output = File.open(output_file, 'w')

pdf = PDF::Reader.new(input_file)

text = ''

pdf.pages.each do |p|
  text << p.text
end

final_text = text.gsub('Autodesk', 'The Company')

output << final_text
output.close

# binding.pry; puts ''