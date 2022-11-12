# # require 'google/apis/civicinfo_v2'
# # require 'csv'

# # civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new

# # civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

# # # response = civic_info.representative_info_by_address(address: 80_202, levels: 'country',
# # #                                                      roles: %w[legislatorUpperBody legislatorLowerBody])
# # # response.officials.each do |kappa|
# # #   puts "#{kappa.name} : #{kappa.party} // #{kappa.address[0].city} && #{kappa.phones[0]}"

# # # end

# # def slick_zipcode(zipcode)
# #   zipcode.to_s.rjust(5, '0')[0..4]
# # end

# # puts 'EventManager initialized'

# # contents = CSV.open('event_attendees.csv', headers: true, header_converters: :symbol)

# # contents.each do |row|
# #   name = row[:first_name]
# #   zipcode = slick_zipcode(row[:zipcode])

# #   legislators = civic_info.respresentative_info_by_address(address: zipcode, levels: 'country',
# #                                                            roles: %w[legislatorUpperBody legislatorLowerBody])
# #   legislators = legislators.officials
# #   puts legislators
# #   #   legislators_names = legislators.map do |legislator|
# #   #     legislator.name
# #   #   end

# #   #   puts "#{name} : #{zipcode} : #{legislators}"
# # end

# require 'csv'
# require 'google/apis/civicinfo_v2'

# # civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
# # civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

# # def clean_zipcode(zipcode)
# #   zipcode.to_s.rjust(5, '0')[0..4]
# # end

# # puts 'EventManager initialized.'

# # contents = CSV.open(
# #   'event_attendees.csv',
# #   headers: true,
# #   header_converters: :symbol
# # )

# # contents.each do |row|
# #   name = row[:first_name]

# #   zipcode = clean_zipcode(row[:zipcode])

# #   begin
# #     legislators = civic_info.representative_info_by_address(
# #       address: zipcode,
# #       levels: 'country',
# #       roles: %w[legislatorUpperBody legislatorLowerBody]
# #     )
# #     legislators = legislators.officials
# #     legislator_names = legislators.map(&:name)
# #     legislator_string = legislator_names.join(', ')
# #   rescue StandardError
# #     'Try looking for your representatives by yourself for once...'
# #   end

# #   puts "#{name} #{zipcode} #{legislator_string}"
# # end

# def slick_zipcode(zipcode)
#   zipcode.to_s.rjust(5, '0')[0..4]
# end

# def legislators_by_zipcode(zip)
#   civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
#   civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

#   begin
#     legislators = civic_info.respresentative_info_by_address(address: zip, levels: 'country', roles: %w[legislatorUpperBody legislatorLowerBody])
#     legislators = legislators.officials
#     legislator_names = legislators.map { |legislator| legislator.name }
#     legislator_names.join(', ')
#   rescue StandardError
#     'Look for your respresentatives yourself...'
#   end
# end

# puts 'EventManager initialized'

# contents = CSV.open('event_attendees.csv', headers: true, header_converters: :symbol)

# contents.each do |row|
#   name = row[:first_name]
#   zipcode = slick_zipcode(row[:zipcode])
#   legislators = legislators_by_zipcode(zipcode)
#   puts "#{name} : #{zipcode} // #{legislators}."
# end

require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: %w[legislatorUpperBody legislatorLowerBody]
    ).officials
    # legislators = legislators.officials
    # legislator_names = legislators.map(&:name)
    # legislator_names.join(', ')
  rescue StandardError
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

puts 'EventManager initialized.'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

contents.each do |row|
  id = row[0]
  name = row[:first_name]

  zipcode = clean_zipcode(row[:zipcode])

  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)

  save_thank_you_letter(id, form_letter)

  # puts form_letter

  # personal_letter = template_letter.gsub('FIRST_NAME', name)
  # personal_letter.gsub!('LEGISLATORS', legislators)
  # puts personal_letter
  # puts "#{name} #{zipcode} #{legislators}"
end
