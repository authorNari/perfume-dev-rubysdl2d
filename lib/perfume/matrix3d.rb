require 'narray'

class Perfume
  class Matrix3D
    class << self
      def translation(x, y, z)
        NMatrix[
            [1.0, 0.0, 0.0, x],
            [0.0, 1.0, 0.0, y],
            [0.0, 0.0, 1.0, z],
            [0.0, 0.0, 0.0, 1.0],
        ]
      end

      def rotationX(angle)
        theta = angle2theta(angle)
        cos = Math.cos(theta)
        sin = Math.sin(theta)
        NMatrix[
            [1.0, 0.0, 0.0, 0.0],
            [0.0, cos, sin, 0.0],
            [0.0, -sin, cos, 0.0],
            [0.0, 0.0, 0.0, 1.0],
        ]
      end

      def rotationY(angle)
        theta = angle2theta(angle)
        cos = Math.cos(theta)
        sin = Math.sin(theta)
        NMatrix[
            [ cos, 0.0, -sin, 0.0],
            [ 0.0, 1.0, 0.0, 0.0],
            [ sin, 0.0, cos, 0.0],
            [ 0.0, 0.0, 0.0, 1.0],
        ]
      end

      def rotationZ(angle)
        theta = angle2theta(angle)
        cos = Math.cos(theta)
        sin = Math.sin(theta)
        NMatrix[
            [ cos, sin, 0.0, 0.0],
            [-sin, cos, 0.0, 0.0],
            [ 0.0, 0.0, 1.0, 0.0],
            [ 0.0, 0.0, 0.0, 1.0],
        ]
      end

      private
      def angle2theta(angle)
        Math::PI / 180 * angle
      end
    end
  end
end
