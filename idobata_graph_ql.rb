require "json"
require "net/http"

class IdobataGraphQL
  IDOBATA_PUBLIC_API_URI = URI.parse("https://api.idobata.io/graphql")

  class << self
    def query(query)
      new(IDOBATA_PUBLIC_API_URI, default_token).query(query)
    end

    def default_token
      ENV.fetch("IDOBATA_TOKEN")
    end
  end

  def initialize(uri, token)
    @uri = uri
    @token = token
  end

  def query(query)
    body = JSON.generate(query: query)
    res = start { |http| http.post(@uri.path, body, headers) }
    res.value
    JSON.parse(res.body).fetch('data')
  end

  private

  def start
    Net::HTTP.start(host, port, use_ssl: scheme == "https") { |http| yield http }
  end

  def headers
    {"Content-Type" => "application/json", "Authorization" => "Bearer #{@token}" }
  end

  def host
    @uri.host
  end

  def port
    @uri.port
  end

  def scheme
    @uri.scheme
  end
end
