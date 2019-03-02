#!/usr/bin/env ruby

require 'optparse'
require 'httparty'
require 'ruby-progressbar'

# This will hold the options we parse
options = {}

OptionParser.new do |parser|

  parser.banner = 'Usage: create_ghost_instance.rb [options]'

  parser.on('-h', '--help', 'Show this help message.') do |_v|
    puts parser
    exit
  end

  parser.on('-u', '--url APISERVER', 'The base URL of the API.') do |v|
    options[:url] = v
  end

  parser.on('-a', '--access_key_id ACCESS_KEY_ID', 'The AWS Access Key ID') do |v|
    options[:access_key_id] = v
  end

  parser.on('-s', '--secret_access_key SECRET_ACCESS_KEY', 'The AWS Secret Access Key') do |v|
    options[:secret_access_key] = v
  end

end.parse!

if options[:url].nil? || options[:access_key_id].nil? || options[:secret_access_key].nil?
  puts 'Invalid arguments.'
  exit
end

result =
  HTTParty.post(
    "#{options[:url]}/instances",
    body: {
      access_key_id: options[:access_key_id],
      secret_access_key: options[:secret_access_key]
    }
  )

puts 'Creating Ghost Instance:'

progressbar = ProgressBar.create(total: 60)

instance_id = result['id']
attemps = 60
status = result['instance_status']
result = {}

while attemps > 0 && status == 'pending'
  result = HTTParty.get(
    "#{options[:url]}/instances/#{instance_id}"
  )

  status = result['instance_status']

  progressbar.increment
  attemps -= 1
  sleep(5)
end

puts "\nInstance Status: #{result['instance_status']}"
puts "Public IP: #{result['public_ip_address']}"
