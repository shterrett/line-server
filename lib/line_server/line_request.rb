class LineRequest
  attr_reader :error

  def initialize(line_number)
    @line_number = coerce_line_number(line_number)
  end

  def line
    if line_number
      find_line
    else
      ''
    end
  end

  private
  attr_reader :line_number

  def find_line
    found = LineFinder.new(Configuration.get.hash_file_dir,
                           Configuration.get.line_max
                          )
                      .find(line_number)
    if found
      found
    else
      @error = :eof
      ''
    end
  end

  def coerce_line_number(line_number)
    if line_number.to_i == line_number || line_number.to_i.to_s == line_number
      line_number.to_i
    else
      @error = :bad_input
      nil
    end
  end
end
