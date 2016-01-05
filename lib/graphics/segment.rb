#
# GIVE CREDIT HERE !!!!!
#

# require "graphics/xy"
require_relative "./xy"
require_relative "./geometria"


class Segment < Struct.new :point1, :point2
  include Geometria
end
