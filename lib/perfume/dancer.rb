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
    end

    def move
      write_joint(@bvh.skeleton.root)
      @frame+=1
    end

    def finished?
      @bvh.frame_count <= @frame
    end

    private
    def write_joint(joint)
      glPushMatrix
      offset = Vector3D[*joint.offset]
      if parent = joint.parent
        translate(Vector3D[*joint.offset])
      else
        c = @bvh.frames[@frame].channel_data_for(joint)
        translate(Vector3D[c['Xposition'], c['Yposition'], c['Zposition']])
      end
      c = @bvh.frames[@frame].channel_data_for(joint)
      if not c['Xrotation'].nil?
        rotate(Vector3D[c['Xrotation'], c['Yrotation'], c['Zrotation']])
      end
      if joint.joints.empty?
        vertex(Vector3D[*joint.offset])
      end
      if joint.joints.size == 1
        j = joint.joints[0]
        vertex(Vector3D[*j.offset])
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
        vertex(Vector3D[center[0], center[1], center[2]]);
        joint.joints.each{|j| vertex(Vector3D[*j.offset], Vector3D[*center]) }
      end
      joint.joints.each_with_index do |j, i|
        write_joint(j)
      end
      glPopMatrix
    end

    def rotate(rotate)
      glMatrixMode( GL_MODELVIEW );
      glRotatef(rotate.x, 1.0, 0.0, 0.0)
      glRotatef(rotate.y, 0.0, 1.0, 0.0)
      glRotatef(rotate.z, 0.0, 0.0, 1.0)
    end

    def vertex(offset, base=Vector3D[0.0, 0.0, 0.0])
      glBegin(GL_LINES)
      glVertex3f(0, 0, 0)
      glVertex3f(offset.x * Perfume::SCALE,
        offset.y * Perfume::SCALE, offset.z * Perfume::SCALE)
      glEnd
    end

    def translate(offset)
      glMatrixMode( GL_MODELVIEW );
      glTranslatef(offset.x * Perfume::SCALE,
        offset.y * Perfume::SCALE, offset.z * Perfume::SCALE)
    end
  end
end
