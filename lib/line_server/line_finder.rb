class LineFinder
  def initialize(hashed_file_directory, line_max)
    @directory = hashed_file_directory
    @line_max = line_max
  end

  def find(line_number)
    line = scan_to_line(enum_file(line_number), line_number)
    cleanup_file
    line
  end

  private
  attr_reader :directory, :file, :line_max

  def scan_to_line(lines, line_number)
    begin
      skip_lines(line_number).times { lines.next }
      line = lines.peek
    rescue StopIteration
      line = nil
    end
  end

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
    if file = hashed_file(line_number)
      file.each_line
    else
      [].to_enum
    end
  end

  def hashed_file(line_number)
    @file = if File.file?(filename(line_number))
              File.open(filename(line_number))
            end
  end

  def cleanup_file
    if file
      file.close
    end
  end
end
