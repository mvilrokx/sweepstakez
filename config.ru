$:<<::File.dirname(__FILE__)

require 'app'

map "/" do
  run App
end