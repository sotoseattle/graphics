##
# The top-level namespace.

class Graphics
  VERSION = "1.0.0b5" # :nodoc:
end

# require "graphics/simulation"
# require "graphics/body"
# require "graphics/wall"
require_relative "./graphics/simulation"
require_relative "./graphics/body"
require_relative "./graphics/wall"
require_relative "./graphics/linear_motion"
