# require "graphics/v"
require_relative "./v"
require_relative "./segment"

class Wall < Segment
  attr_accessor :uni, :point1, :point2

  ##
  # A Wall, a segment where each point is defined by vectors.

  def initialize v1, v2
    self.point1, self.point2 = v1, v2
    self.uni = (point2 - point1).unit
  end

  ##
  # Override to alter behavior.

  def reaction_to b
    bounce b
  end

  ##
  # Bounce by reversing the perpend force.

  def bounce b
    n = uni.perp_projection b.velocity
    n *= 2
    n.reverse
  end

  ##
  # Clip by annuling the perpendicular force.

  def clip b
    uni.perp_projection(b.velocity).reverse
  end

end
