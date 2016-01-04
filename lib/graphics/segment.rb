#
# GIVE CREDIT HERE !!!!!
#

# require "graphics/xy"
require_relative "./xy"

class Segment < Struct.new(:point1, :point2)

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
      lies_on_line_intersecting?(other) &&
      other.lies_on_line_intersecting?(self)
  end

  def intersection_point_with(segment)
    # raise SegmentsDoNotIntersect unless intersects_with?(segment)
    # raise SegmentsOverlap if overlaps?(segment)
    return nil unless intersects_with?(segment)

    numerator = (segment.point1.y - point1.y) * (segment.point1.x - segment.point2.x) -
      (segment.point1.y - segment.point2.y) * (segment.point1.x - point1.x);
    denominator = (point2.y - point1.y) * (segment.point1.x - segment.point2.x) -
      (segment.point1.y - segment.point2.y) * (point2.x - point1.x);

    t = numerator.to_f / denominator;

    x1 = point1.x + t * (point2.x - point1.x)
    y1 = point1.y + t * (point2.y - point1.y)

    # Point.new(x, y)
    XY[x1, y1]
  end

  def to_vector
    Graphics::V.new(x: point2.x - point1.x, y: point2.y - point1.y)
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

  def lies_on_line_intersecting?(segment)
    vector_to_1st = Graphics::V.new
    vector_to_1st.position = self.point1
    vector_to_1st.endpoint = segment.point1

    vector_to_2nd = Graphics::V.new
    vector_to_2nd.position = self.point1
    vector_to_2nd.endpoint = segment.point2

    #FIXME: '>=' and '<=' method of Fixnum and Float should be overriden too (take precision into account)
    # there is a rare case, when this method is wrong due to precision

    my_vector = Graphics::V.new
    my_vector.position = self.point1
    my_vector.endpoint = self.point2

    my_vector.cross_prod(vector_to_1st) * my_vector.cross_prod(vector_to_2nd) <= 0
  end
end
