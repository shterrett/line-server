require 'benchmark'

sizes = (1..7).map { |n| n * 4 }

line = 'There are four lights!'

sizes.each do |size|
  File.open("./#{size}.txt", 'w') do |f|
    (2 ** size).times { f.puts line }
  end
end

File.open('./results.txt', 'w') do |f|
  sizes.each do |size|
    f.puts(Benchmark.measure do
            lines = File.open("./#{size}.txt", 'r').each_line
            (2 ** (size - 1)).times { lines.next }
            f.puts "#{lines.peek} | #{size}"
          end
          )
  end
end

sizes.each do |size|
  File.delete("./#{size}.txt")
end
