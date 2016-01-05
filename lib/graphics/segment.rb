#
# GIVE CREDIT HERE !!!!!
#

# require "graphics/xy"
require_relative "./xy"

class Segment < Struct.new :point1, :point2

  def leftmost_endpoint
    ((point1.x <=> point2.x) == -1) ? point1 : point2
  end

  def rightmost_endpoint
    ((point1.x <=> point2.x) == 1) ? point1 : point2
  end

  def topmost_endpoint
    ((point1.y <=> point2.y) == 1) ? point1 : point2
  end

  def bottommost_endpoint
    ((point1.y <=> point2.y) == -1) ? point1 : point2
  end

  def intersects_with?(other)
    Segment.have_intersecting_bounds?(self, other) &&
      self.lies_on_line_intersecting?(other) &&
      other.lies_on_line_intersecting?(self)
  end

  def overlaps?(o)
    # Segment.have_intersecting_bounds?(self, other) && # NOT CHECKING BEWARE
    o1 = Segment.new self.point1, o.point1
    o2 = Segment.new self.point1, o.point2
    (dot_product(o1) === 0) && (dot_product(o2) === 0)
  end

  def intersection_point_with(o)
    return nil unless intersects_with?(o)
    return nil if overlaps?(o)

    numerator = (o.point1.y - point1.y) * (o.point1.x - o.point2.x) -
      (o.point1.y - o.point2.y) * (o.point1.x - point1.x);
    denominator = (point2.y - point1.y) * (o.point1.x - o.point2.x) -
      (o.point1.y - o.point2.y) * (point2.x - point1.x);

    t = numerator.to_f / denominator;

    x1 = point1.x + t * (point2.x - point1.x)
    y1 = point1.y + t * (point2.y - point1.y)

    XY[x1, y1]
  end

  protected

  def self.have_intersecting_bounds?(segment1, segment2)
    intersects_on_x_axis =
      (segment1.leftmost_endpoint.x < segment2.rightmost_endpoint.x ||
      segment1.leftmost_endpoint.x == segment2.rightmost_endpoint.x) &&
      (segment2.leftmost_endpoint.x < segment1.rightmost_endpoint.x ||
      segment2.leftmost_endpoint.x == segment1.rightmost_endpoint.x)

    intersects_on_y_axis =
      (segment1.bottommost_endpoint.y < segment2.topmost_endpoint.y ||
      segment1.bottommost_endpoint.y == segment2.topmost_endpoint.y) &&
      (segment2.bottommost_endpoint.y < segment1.topmost_endpoint.y ||
      segment2.bottommost_endpoint.y == segment1.topmost_endpoint.y)

    intersects_on_x_axis && intersects_on_y_axis
  end

  def lies_on_line_intersecting?(o)
    o1 = Segment.new self.point1, o.point1
    o2 = Segment.new self.point1, o.point2

    # FIXME: '>=' and '<=' method of Fixnum and Float should be
    # overriden too (take precision into account), there is a
    # rare case, when this method is wrong due to precision

    dot_product(o1) * dot_product(o2) <= 0
  end

  def dot_product o
    dx = point2.x - point1.x
    dy = point2.y - point1.y
    odx = o.point2.x - o.point1.x
    ody = o.point2.y - o.point1.y

    dx * ody - dy * odx
  end
end
