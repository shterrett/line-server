module TempFileManagement
  def clean_tmp_folder(tmp_dir)
    DirectoryCleaner.new(tmp_dir).clean
  end

  def create_searchable_files(tmp_dir:,
                              line_max:,
                              complete_files:,
                              partial_file_lines: 0
                             )
    (0..complete_files).map { |n| n * line_max }.each do |start|
      File.open("#{tmp_dir}/#{start}.txt", 'w') do |f|
        (0...line_max).each do |line|
          f.puts file_line(start, line)
        end
      end
    end

    if partial_file_lines > 0
      File.open("#{tmp_dir}/#{line_max * (complete_files + 1)}.txt", 'w') do |f|
        (0...partial_file_lines).each do |line|
          f.puts file_line(line_max * (complete_files + 1), line)
        end
      end
    end
  end

  def file_line(start, line)
    "file #{start}; line #{line}; total #{start + line}"
  end
end
