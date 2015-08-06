class DirectoryCleaner
  def initialize(directory_path)
    @path = directory_path
  end

  def clean
    Dir.new(path).entries.each do |entry|
      if File.file?("#{path}/#{entry}")
        File.delete("#{path}/#{entry}")
      end
    end
  end

  private
  attr_reader :path
end
