#!/usr/bin/env ruby
# frozen_string_literal: true

# Fetch Advent of Code puzzle input
#
# Usage:
#   ruby bin/fetch_input.rb YEAR DAY
#   ruby bin/fetch_input.rb 2022 1
#
# Requires AOC_SESSION environment variable or .aoc_session file
# containing your session cookie from adventofcode.com

require 'net/http'
require 'uri'
require 'fileutils'

def session_cookie
  # Try environment variable first
  return ENV['AOC_SESSION'] if ENV['AOC_SESSION']

  # Try .aoc_session file
  session_file = File.join(__dir__, '..', '.aoc_session')
  return File.read(session_file).strip if File.exist?(session_file)

  # Try .env file
  env_file = File.join(__dir__, '..', '.env')
  if File.exist?(env_file)
    File.readlines(env_file).each do |line|
      if line.start_with?('AOC_SESSION=')
        return line.split('=', 2).last.strip
      end
    end
  end

  nil
end

def fetch_input(year, day)
  cookie = session_cookie
  unless cookie
    warn 'Error: No session cookie found!'
    warn 'Set AOC_SESSION environment variable or create .aoc_session file'
    warn 'See .env.example for instructions on getting your session cookie'
    exit 1
  end

  uri = URI("https://adventofcode.com/#{year}/day/#{day}/input")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  request = Net::HTTP::Get.new(uri)
  request['Cookie'] = "session=#{cookie}"
  request['User-Agent'] = 'github.com/aygp-dr/aoc-rb by jwalsh'

  response = http.request(request)

  case response.code
  when '200'
    response.body
  when '400'
    warn "Error 400: Bad request (session cookie may be invalid)"
    exit 1
  when '404'
    warn "Error 404: Puzzle not found (year=#{year}, day=#{day})"
    exit 1
  else
    warn "Error #{response.code}: #{response.message}"
    exit 1
  end
end

def save_input(year, day, content)
  day_str = day.to_s.rjust(2, '0')
  dir = File.join(__dir__, '..', year.to_s, "day#{day_str}")

  FileUtils.mkdir_p(dir)

  input_file = File.join(dir, 'input.txt')
  File.write(input_file, content)

  puts "Saved input to #{input_file}"
  puts "#{content.lines.count} lines, #{content.bytesize} bytes"
end

if __FILE__ == $0
  if ARGV.length < 2
    warn "Usage: #{$0} YEAR DAY"
    warn "Example: #{$0} 2022 1"
    exit 1
  end

  year = ARGV[0].to_i
  day = ARGV[1].to_i

  unless (2015..Time.now.year).include?(year)
    warn "Invalid year: #{year}"
    exit 1
  end

  unless (1..25).include?(day)
    warn "Invalid day: #{day}"
    exit 1
  end

  puts "Fetching input for #{year} Day #{day}..."
  content = fetch_input(year, day)
  save_input(year, day, content)
end
