require 'matrix'

class Perfume
  # based on this site.
  # http://dgames.jp/dan/20080111
  class Vector3D < Array
    %w(x y z).each_with_index do |e, i|
      eval "def #{e} ; self[#{i}] ; end"
      eval "def #{e}=a ; self[#{i}] = a ; end"
    end
    %w(+ - * /).each do |e|
      eval "def #{e}d
              Vector3D[self[0] #{e} d[0], self[1] #{e} d[1], self[2] #{e} d[2]]
            end"
    end
  
    include Math
    def rotate_yxz(angle)
      ax, ay, az = angle.map{|i| Math::PI / 180 * i}
      px, py, pz = x, y, z

      py, pz = py * cos(ax) - pz * sin(ax), py * sin(ax) + pz * cos(ax)
      px, py = px * cos(az) - py * sin(az), px * sin(az) + py * cos(az)
      pz, px = pz * cos(ay) - px * sin(ay), pz * sin(ay) + px * cos(ay)
      Vector3D[px, py, pz]
    end
  end
end
