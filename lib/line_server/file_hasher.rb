class FileHasher
  def initialize(file:, target:, line_max:)
    @file = file
    @target = target
    @line_max = line_max
    @name = 0
  end

  def hash_file
    file_enumerator.each_slice(line_max) do |lines|
      write_partial_file(lines)
      @name += line_max
    end
    file_object.close
  end

  private
  attr_reader :file, :line_max, :name, :target

  def write_partial_file(lines)
    new_file do |f|
      f.puts lines
    end
  end

  def new_file
    File.open("#{target}/#{name}.txt", 'w') do |f|
      yield f
    end
  end

  def file_enumerator
    @enumerator ||= file_object.each_line
  end

  def file_object
    @file_object ||= File.open(file, 'r')
  end
end
