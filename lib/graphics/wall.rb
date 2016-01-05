# require "graphics/v"
# require "graphics/segment"
require_relative "./v"
require_relative "./segment"

class Wall < Segment
  attr_accessor :f

  ##
  # A Wall, a segment defined by two endpoints, and
  # a vector perpendicular to it.

  def initialize xy1, xy2
    super xy1, xy2

    self.f = Graphics::V.new
    self.f.position = point1
    self.f.endpoint = point2
    self.f.m = 0
  end

  ##
  # Perpendicular reaction vector. Override to alter behavior.

  def reaction_to b
    n = self.f.dup
    n.m = b.m

    # angle of normal vector depending on where the ball comes from.
    prod = b.dot n
    orientation = prod > 0 ? 90 : -90
    n.a += orientation

    # magnitude of reaction vector.
    n.m = bounce b, n

    n
  end

  ##
  # Collinear projection of vector over another.

  def projection v, u
    v.scalar_prod(u) / v.m
  end

  ##
  # Perpendicular projection of vector over another.

  def bounce body, barrier
    proj_m = projection body, barrier
    proj_m.abs - proj_m
  end

  ##
  # Perpendicular partial projection to neutralize movement over that axis.

  def clip body, barrier
    projection(body, barrier).abs
  end

end
