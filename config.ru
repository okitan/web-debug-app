require "rack/spyup"
require "coderay" # TODO: make a PR

require "logger"
require "json"

use Rack::SpyUp do |c|
  c.logger = Logger.new(STDOUT)
end

run ->(env) {
  request = ::Rack::Request.new(env)
  [ 200,
    { "Content-Type" => "application/json" },
    [
      JSON.dump(
        "HTTP_METHOD" => request.request_method,
        "URL"         => request.url,
        "HEADERS"     => request.env.select { |k, v| k.start_with?('HTTP_') },
        "PARAMS"      => (request.POST rescue nil),
      )
    ]
  ]
}
