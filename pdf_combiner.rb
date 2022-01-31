require 'combine_pdf'
require 'pry'

filepath = ARGV[0]

pdf = CombinePDF.new
pdf << CombinePDF.load(filepath)

binding.pry

puts "Under construction ..."