class Icon < ApplicationRecord
  BUCKET = ENV["AWS_S3_BUCKET_ICONS"]

  def self.fingerprint(data)
    Digest::MD5.hexdigest(data)
  end

  def self.signed_path(url)
    signature = OpenSSL::HMAC.hexdigest("sha1", secret_key, url)
    hex = url.to_enum(:each_byte).map { |byte| "%02x" % byte }.join
    "/#{signature}/#{hex}"
  end

  def self.signed_url(url)
    URI::HTTPS.build(
      host: ENV["ICONS_HOST"],
      path: signed_path(url)
    )
  end

  def self.secret_key
    ENV.fetch("CAMO_KEY", "secret")
  end

  def self.decode(string)
    string.scan(/../).map { |x| x.hex.chr }.join
  end

  def self.signature_valid?(signature, data)
    signature == OpenSSL::HMAC.hexdigest("sha1", secret_key, data)
  end
end
