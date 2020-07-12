class Uploads
  REGEXP = /\Adata:(?<type>[-\w]+\/[-\w\+\.]+)?;base64,(?<content>.*)/m
  EXT = /image\/(?<ext>\w+).*/

  attr_reader :data_uri

  def self.call(data_uri)
    new(data_uri).call
  end

  def initialize(data_uri)
    @data_uri = data_uri
  end

  def call
    data_uri_parts = data_uri.match(REGEXP) || {}
    {
      io: diet(Base64.decode64(data_uri_parts[:content] || '')),
      content_type: 'image/jpeg',
      filename: "#{SecureRandom.uuid}.jpg"
    }
  end

  private

  def diet(content)
    return StringIO.new('') if content.empty?

    original = Tempfile.new('mersea.uploaded', binmode: true)
    original << content
    original.close

    processed = ImageProcessing::MiniMagick
    .source(original.path)
    .resize_to_limit(1920, 1080)
    .quality(90)
    .convert("jpg")
    .call(save: true)

    StringIO.new(processed.read)
  ensure
    original&.unlink
    processed&.close
    processed&.unlink
  end
end
