require 'csv'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)
result = []
contents.each do |row|
  dates = row[:regdate]
  times = dates.split(' ')[1]
  hours = times.split(':')[0]
  result.push(hours)
end

value = result.map { |v| v.to_i }

hash = Hash.new(0)
result.each do |v|
  hash[v] += 1
end

hash.each do |k, v|
  values = hash.values
  puts "The most common registration hours were #{k}:00 with #{v} registrations." if v == values.max
end
