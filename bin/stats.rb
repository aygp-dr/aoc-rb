#!/usr/bin/env ruby
#!/usr/bin/env ruby

years = Dir.glob('20*/').map { |d| d.delete_suffix('/') }.sort

years.each do |year|
  days = Dir.glob("#{year}/day*/solution.rb").length
  puts "#{year}: #{days}/25 days"
end
