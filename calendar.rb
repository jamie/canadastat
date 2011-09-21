$LOAD_PATH << 'lib'
require 'holidays'

Holiday.all(2011, ARGV[0] || Holiday.provinces).each do |holiday|
  puts holiday
end
