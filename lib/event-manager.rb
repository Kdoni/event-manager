puts 'Event Manager Initialized!'

# content = File.read('event_attendees.csv')

# # puts content

# puts File.exist? 'event_attendees.csv'

lines = File.readlines('event_attendees.csv')
lines.each do |line|
  next if line == " ,RegDate,first_Name,last_Name,Email_Address,HomePhone,Street,City,State,Zipcode\n"

  columns = line.split(',')
  name = columns[2]
  puts name
end
