require "json"
require "net/http"

class IdobataGraphQL
  class Room < Struct.new(:id, :name, :organization); end

  IDOBATA_PUBLIC_API_URI = URI.parse("https://api.idobata.io/graphql")

  class << self
    def query(query)
      default.query(query)
    end

    def rooms
      default.rooms
    end

    def create_message(room_id, source, format = 'MARKDOWN')
      default.create_message(room_id, source, format)
    end

    private

    def default
      new(IDOBATA_PUBLIC_API_URI, default_token)
    end

    def default_token
      ENV.fetch("IDOBATA_TOKEN")
    end
  end

  def initialize(uri, token)
    @uri = uri
    @token = token
  end

  def query(query, variables = nil)
    body = JSON.generate({ query: query, variables: variables }.compact)
    res = start { |http| http.post(@uri.path, body, headers) }
    res.value
    JSON.parse(res.body).fetch('data')
  end

  def create_message(room_id, source, format)
    variables = { input: { roomId: room_id, source: source, format: format } }
    query(<<~MUTATION, variables)
    mutation Mutation($input: CreateMessageInput!) {
      createMessage(input: $input) {
        clientMutationId
      }
    }
    MUTATION
  end

  def rooms
    fetch_rooms.dig('viewer', 'rooms', 'edges').map do |room_edge|
      Room.new(
        room_edge.dig('node', 'id'),
        room_edge.dig('node', 'name'),
        room_edge.dig('node', 'organization', 'name'),
      )
    end
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

  def fetch_rooms
    query('query { viewer { rooms { edges { node { id, name, organization { name } } } } } }')
  end

end
