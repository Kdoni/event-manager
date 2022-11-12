require 'csv'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

def filter_phones(homephone)
  phone = homephone.gsub(/[A-Z]|\+|\.|-|\(|\)|\s+/, '')
  if phone.length < 10
    phone = 'invalid phone number...'
  elsif phone.length > 10
    phone = phone.split('').slice(1, 10).join('')
    phone
  end
  phone
end

contents.each do |row|
  phone = filter_phones(row[:homephone])
  puts phone
end
