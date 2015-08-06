class LineMaxCalculator
  def initialize(path_to_file)
    @path = path_to_file
  end

  def line_max
    max = (lines / number_of_files).ceil
    if max < 1024
      max
    else
      1024
    end
  end

  private
  attr_reader :path

  def number_of_files
    Math::log(lines, 2)
  end

  def lines
    return @lines if @lines

    File.open(path) do |f|
      @lines = f.each_line.reduce(0) { |n, line| n + 1 }
    end
    @lines
  end
end
