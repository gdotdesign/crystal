require './specrunner'

use Rack::Reloader
use Rack::Static, :urls => ['/vendor'], :root => 'public'

run Specrunner