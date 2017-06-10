require_relative "boot"

use Rack::Deflater, if: ->(_, _, _, body) { body.any? && body[0].length > 512 }

use Exporter

app = lambda do |_|
  [404, { "Content-Type" => "text/html" }, ["Not Found"]]
end

run app
