require 'csv'

puts 'Event Manager Initialized!'

# content = File.read('event_attendees.csv')

# # puts content

# puts File.exist? 'event_attendees.csv'

# lines = File.readlines('event_attendees.csv')
# lines.each do |line|
#   next if line == " ,RegDate,first_Name,last_Name,Email_Address,HomePhone,Street,City,State,Zipcode\n"

#   columns = line.split(',')
#   name = columns[2]
#   puts name
# end

# contents = CSV.open('event_attendees.csv', headers: true)
# contents.each do |row|
#   name = row[2]
#   puts name
# end

contents = CSV.open('event_attendees.csv', headers: true, header_converters: :symbol)

# contents.each do |row|
#   # p row
#   name = row[:first_name]
#   zipcode = row[:zipcode]
#   zipcode = '00000' if zipcode.nil?
#   zipcode = '0' + zipcode while zipcode.length < 5
#   puts "#{name} : #{zipcode}"
# end

def slick_zipcode(zipcode)
  # zipcode = '00000' if zipcode.nil?
  # zipcode = '0' + zipcode while zipcode.length < 5
  # while zipcode.length > 5
  #   zipcode.pop
  #   zipcode
  # end
  # zipcode
  zipcode.to_s.rjust(5, '0')[0..4]
end

contents.each do |row|
  name = row[:first_name]
  zipcode = slick_zipcode(row[:zipcode])
  puts "#{name} : #{zipcode}"
end
