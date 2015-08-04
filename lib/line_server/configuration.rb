class Configuration
  attr_accessor :hash_file_dir, :line_max

  def self.set
    @config ||= new
    yield @config
  end

  def self.get
    @config
  end
end
