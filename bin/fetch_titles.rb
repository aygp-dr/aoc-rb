#!/usr/bin/env ruby
# frozen_string_literal: true

# Fetch Advent of Code puzzle titles for all years
#
# Usage:
#   ruby bin/fetch_titles.rb
#   ruby bin/fetch_titles.rb 2015
#   ruby bin/fetch_titles.rb 2015 2024

require 'net/http'
require 'uri'
require 'json'

def fetch_day_title(year, day)
  uri = URI("https://adventofcode.com/#{year}/day/#{day}")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  request = Net::HTTP::Get.new(uri)
  request['User-Agent'] = 'github.com/aygp-dr/aoc-rb puzzle title fetcher'

  response = http.request(request)

  return nil unless response.code == '200'

  # Extract title from HTML: <h2>--- Day N: Title ---</h2>
  if response.body =~ /<h2>--- Day \d+: (.+?) ---<\/h2>/
    $1.strip
  end
rescue => e
  warn "Error fetching #{year}/#{day}: #{e.message}"
  nil
end

def fetch_year_titles(year)
  titles = {}
  (1..25).each do |day|
    print "Fetching #{year} Day #{day}... "
    title = fetch_day_title(year, day)
    if title
      titles[day] = title
      puts title
    else
      puts "(not available)"
    end
    sleep 0.5  # Be nice to the server
  end
  titles
end

def main
  start_year = ARGV[0]&.to_i || 2015
  end_year = ARGV[1]&.to_i || 2024

  all_titles = {}

  (start_year..end_year).each do |year|
    puts "\n=== #{year} ==="
    all_titles[year] = fetch_year_titles(year)
  end

  # Output as JSON
  output_file = File.join(__dir__, '..', 'data', 'puzzle_titles.json')
  require 'fileutils'
  FileUtils.mkdir_p(File.dirname(output_file))
  File.write(output_file, JSON.pretty_generate(all_titles))
  puts "\nSaved to #{output_file}"

  # Also output as org-mode table
  puts "\n* Puzzle Titles\n"
  all_titles.each do |year, days|
    puts "\n** #{year}\n"
    puts "| Day | Title |"
    puts "|-----|-------|"
    days.each do |day, title|
      puts "| #{day.to_s.rjust(2)} | #{title} |"
    end
  end
end

if __FILE__ == $0
  main
end
