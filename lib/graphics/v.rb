# Simple and fast 2D vector

class V

  # degrees to radians
  D2R = Graphics::Simulation::D2R

  # radians to degrees
  R2D = Graphics::Simulation::R2D

  # starting point x coordinate -- preferably float
  attr_accessor :x

  # starting point y coordinate -- preferably float
  attr_accessor :y

  class << self
    alias :[] :new # :nodoc:
  end

  def initialize x, y
    self.x = x
    self.y = y
  end

  def self.new_polar a = 0.0, m = 0.0
    self.polar_to_cart a, m
  end

  def cart_to_polar
    a = Math.atan2(y, x) * R2D
    m = Math.sqrt(x**2 + y**2)
    { a: a, m: m }
  end

  def self.polar_to_cart a, m
    rad = a * D2R
    dx = Math.cos(rad) * m
    dy = Math.sin(rad) * m
    V[dx, dy]
  end

  def + w
    V.new x + w.x, y + w.y
  end

  def - w
    V.new x - w.x, y - w.y
  end

  def * s
    V.new x * s, y * s
  end

  def / s
    V.new x / s, y / s
  end

  def == other # :nodoc:
    x == other.x && y == other.y
  end

  def distance_to w
    Math.hypot x - w.x, y - w.y
  end

  def dist_to_origin
    Math.sqrt(x*x + y*y)
  end
  alias_method :magnitude, :dist_to_origin

  def angle
    (R2D * Math.atan2(y, x)).degrees
  end

  def angle_to w
    V[w.x - x, w.y - y].angle
  end

  def inspect # :nodoc:
    "#{self.class.name}[%.2f, %.2f]" % [x, y]
  end
  alias to_s inspect # :nodoc:

  def to_a
    [x, y]
  end

  def turn beta
    if beta
      a = (angle + beta).degrees
      self.x, self.y = V.polar_to_cart(a, magnitude).to_a
    end
  end

  def reverse
    self.dup * -1
  end

  def collinear_with? w
    x * w.y + y * w.x === 0
  end

  def dot w
    x * w.y - y * w.x
  end

  def scalar_prod w
    x * w.x + y * w.y
  end

  ##
  # Collinear projection of vector [v] over self.

  def coll_projection v
    u = self.unit
    u * v.scalar_prod(u)
  end

  ##
  # Perpendicular projection of vector [v] over self.

  def perp_projection v
    v - coll_projection(v)
  end

  def unit
    cp = self.dup
    cp / cp.magnitude
  end

end
