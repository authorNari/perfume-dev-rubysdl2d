require 'bvh'

class Perfume
  class Color
    WHITE = [255, 255, 255]
    GRAY = [225, 225, 225]
    BLUE = [0, 0, 255]
    BLACK = [0, 0, 0]
  end

  class Dancer
    def initialize(filepath)
      @frame = 0
      @bvh = Bvh.import(filepath)
      @base_matrix = Matrix3D.rotationX(-10)
    end

    def move
      @base_matrix *= Matrix3D.rotationY(0.1)
      write_joint(@base_matrix, @bvh.skeleton.root)
      @frame+=1
    end

    def finished?
      @bvh.frame_count <= @frame
    end

    private
    def write_joint(base, joint)
      if parent = joint.parent
        base = base * Matrix3D.translation(
          joint.offset[0], joint.offset[1], joint.offset[2])
      else
        c = @bvh.frames[@frame].channel_data_for(joint)
        base = base * Matrix3D.translation(
          c['Xposition'], c['Yposition'], c['Zposition'])
      end
      c = @bvh.frames[@frame].channel_data_for(joint)
      if not c['Xrotation'].nil?
        base = base *
          Matrix3D.rotationY(-c['Yrotation']) *
          Matrix3D.rotationX(-c['Xrotation']) *
          Matrix3D.rotationZ(-c['Zrotation'])
      end

      if joint.joints.empty?
        write_edge(base)
      end
      if joint.joints.size == 1
        j = joint.joints[0]
        write_bone(base, j.offset)
      end
      if joint.joints.size > 1
        center = [0.0, 0.0, 0.0]
        joint.joints.each do |j|
          center[0] += j.offset[0]
          center[1] += j.offset[1]
          center[2] += j.offset[2]
        end
        center[0] /= joint.joints.size + 1;
        center[1] /= joint.joints.size + 1;
        center[2] /= joint.joints.size + 1;
        write_bone(base, center);
        center = base * Matrix3D.translation(*center)
        joint.joints.each{|j| write_bone(center, joint.offset) }
      end
      joint.joints.each{|j| write_bone(base, j.offset) }
      
      joint.joints.each_with_index do |j, i|
        write_joint(base, j)
      end
    end

    def write_edge(matrix)
      base = matrix * NVector[0.0, 0.0, 0.0, 1.0]
      Perfume.screen.draw_circle(base[0] + 400, 300 - base[1], 10, Color::BLACK, true)
    end

    def write_bone(matrix, offset)
      base = matrix * NVector[0.0, 0.0, 0.0, 1.0]
      offset = matrix * NVector[offset[0], offset[1], offset[2], 1.0]
      Perfume.screen.draw_line(
        base[0] + 400, 300 - base[1],
        offset[0] + 400, 300 - offset[1], Color::BLACK
      )
    end
  end
end
