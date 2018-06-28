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
    ext = ((data_uri_parts[:type] || '').match(EXT) || {})[:ext] || '.png'
    {
      io: StringIO.new(Base64.decode64(data_uri_parts[:content] || '')),
      content_type: data_uri_parts[:type],
      filename: "#{SecureRandom.uuid}.#{ext}"
    }
  end
end
