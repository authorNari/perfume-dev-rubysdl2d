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
      @base_rotate = Vector3D[10, 0, 0]
    end

    def move
      p @frame
      @base_rotate += Vector3D[0, 1, 0]
      root = @bvh.skeleton.root
      c = @bvh.frames[@frame].channel_data_for(root)
      write_joint(@base_rotate,
        Vector3D[c['Xposition'], c['Yposition'], c['Zposition']].
          rotate_yxz(@base_rotate),
        root)
      @frame+=1
    end

    def finished?
      @bvh.frame_count <= @frame
    end

    private
    def write_joint(rotate, base, site)
      offset = vec = base + (Vector3D[*site.offset].rotate_yxz(@base_rotate + rotate))
      # p({name: site.name, x: vec.x.to_i,
      #   y: vec.y.to_i, rotate: rotate, base: base,
      #   site_offset: site.offset,
      #   after: (Vector3D[*site.offset].rotate_yxz(rotate))})
      # Perfume.screen[vec.x.to_i + 400, 300 - vec.y.to_i] = Color::BLACK
      Perfume.screen.draw_line(
        base.x.to_i + 400, 300 - base.y.to_i,
        vec.x.to_i + 400, 300 - vec.y.to_i, Color::BLACK
      )
      # Perfume.small_font.draw_solid_utf8(
      #   Perfume.screen, site.name.to_s.inspect,
      #   (vec.x.to_i + 100), (300 - vec.y.to_i),
      #   *Color::WHITE)
      channel = @bvh.frames[@frame].channel_data_for(site)
      site.joints.each_with_index do |j, i|
        if i == 0
          write_joint(
            [channel['Xrotation'], channel['Yrotation'], channel['Zrotation']],
            offset, j)
        else
          write_joint(@base_rotate, offset, j)
        end
      end
    end

    def frame
    end
  end
end
