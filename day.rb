require 'csv'
require 'date'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)
result = []
contents.each do |row|
  dates = row[:regdate]
  days = dates.split(' ')[0]
  array = days.split('/').map { |value| value.to_i }
  result.push(Date.new(array[2], array[0], array[1]).wday)
end

hash = Hash.new(0)
result.each do |value|
  hash[value] += 1
end

# days_array = hash.values

# p days_array.max
# p Date::DAYNAMES[1]
# # p hash
# # p result
# # p Date::DAYNAMES

hash.each do |k, v|
  days_array = hash.values
  puts "Most people were registered on #{Date::DAYNAMES[k - 1]}, with #{v} people registered." if v == days_array.max
end
