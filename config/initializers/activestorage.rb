ActiveStorage::Filename.class_eval do
  def sanitized
    # Use custom sanitization for ActiveStorage filenames
    "#{SecureRandom.hex(4)}#{File.extname(@filename.strip)}"
  end
end
