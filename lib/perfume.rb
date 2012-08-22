require 'sdl'
require_relative 'fpstimer'
require_relative "perfume/matrix3d"
require_relative "perfume/dancer"

class Perfume
  WIDTH = 800
  HEIGHT = 400
  class << self
    attr_reader :screen
    attr_reader :small_font

    def play
      GC.disable # OMG...
      SDL.init(SDL::INIT_EVERYTHING)
      SDL::TTF.init
      @screen = SDL.set_video_mode(
        WIDTH, HEIGHT, 16, SDL::HWSURFACE|SDL::DOUBLEBUF)
      SDL::WM.set_caption("#perfume-dev", "")

      dancers = [
        "../data/bvhfiles/aachan.bvh",
        "../data/bvhfiles/kashiyuka.bvh",
        "../data/bvhfiles/nocchi.bvh",
      ].map do |f|
        Dancer.new(File.expand_path(f, File.dirname(__FILE__)))
      end

      timer = FPSTimerLight.new(40)
      timer.reset

      loop {
        screen.fill_rect(0, 0, WIDTH, HEIGHT, Color::WHITE)
        dancers.map(&:move)
        break if dancers.first.finished?
        timer.wait_frame {
          screen.update_rect(0, 0, WIDTH, HEIGHT)
        }
      }
    end
  end
end
