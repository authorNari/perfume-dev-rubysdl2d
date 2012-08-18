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
      # @frame = 2600
      @bvh = Bvh.import(filepath)
      @base_rotate = Vector3D[0, 0, 0]
    end

    def move
      p @frame
      @base_rotate += Vector3D[0, 0, 0]
      root = @bvh.skeleton.root
      c = @bvh.frames[@frame].channel_data_for(root)
      write_joint(@base_rotate, root,
        Vector3D[c['Xposition'], c['Yposition'], c['Zposition']])
      @frame+=1
    end

    def finished?
      @bvh.frame_count <= @frame
    end

    private
    def write_joint(rotate, site, offset)
      glPushMatrix
      rotate(rotate)
      site.name == "Hips" ? translate(offset) : vertex(offset)
      # p({name: site.name, x: vec.x.to_i,
      #   y: vec.y.to_i, rotate: rotate,
      #   base: offset_points(base.x, base.y),
      #   site_offset: site.offset,
      #   after: (Vector3D[*site.offset].rotate_yxz(rotate)),
      #   vec: offset_points(vec.x, vec.y)})
      # if site.name == nil
      #   Perfume.screen.draw_circle(
      #     *offset_points(vec.x, vec.y), 5, Color::BLACK, true
      #   )
      # end
      channel = @bvh.frames[@frame].channel_data_for(site)
      site.joints.each_with_index do |j, i|
        write_joint(
          Vector3D[
            channel['Xrotation'],
            channel['Yrotation'],
            channel['Zrotation'],
          ], j, Vector3D[*j.offset])
      end
      glPopMatrix
    end

    def rotate(rotate)
      glMatrixMode( GL_MODELVIEW );
      glRotate(rotate.x, 1, 0, 0)
      glRotate(rotate.y, 0, 1, 0)
      glRotate(rotate.z, 0, 0, 1)
    end

    def vertex(offset)
      glBegin(GL_LINES)
      glVertex3f(0, 0, 0)
      glVertex3f(offset.x / 600.0, offset.y / 600.0, offset.z / 600.0)
      glEnd
      translate(offset)
    end

    def translate(offset)
      glMatrixMode( GL_MODELVIEW );
      glTranslatef(offset.x / 600.0, offset.y / 600.0, offset.z / 600.0)
    end
  end
end
