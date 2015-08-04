class LineFinder
  def initialize(hashed_file_directory, line_max)
    @directory = hashed_file_directory
    @line_max = line_max
  end

  def find(line_number)
    lines = enum_file(line_number)
    skip_lines(line_number).times { lines.next }
    line = lines.peek
    cleanup_file
    line
  end

  private
  attr_reader :directory, :file, :line_max

  def skip_lines(line_number)
    line_number - file_index(line_number)
  end

  def filename(line_number)
    "#{directory}/#{file_index(line_number)}.txt"
  end

  def file_index(line_number)
    (line_number / line_max) * line_max
  end

  def enum_file(line_number)
    @file = File.open(filename(line_number))
    @file.each_line
  end

  def cleanup_file
    file.close
  end
end
