require 'sdl'
require_relative "perfume/vector3d"
require_relative "perfume/dancer"

class Perfume
  WIDTH = 800
  HEIGHT = 400
  class << self
    attr_reader :screen
    attr_reader :small_font

    def play
      SDL.init(SDL::INIT_EVERYTHING)
      SDL::TTF.init
      @screen = SDL.set_video_mode(
        WIDTH, HEIGHT, 16, SDL::HWSURFACE|SDL::DOUBLEBUF)
      SDL::WM.set_caption("#perfume-dev", "")
      font_path = File.join(File.dirname(__FILE__), 'fonts/VeraMoBd.ttf')
      @small_font = SDL::TTF.open(font_path, 8)

      dancers = [
        "../data/bvhfiles/aachan.bvh",
        "../data/bvhfiles/kashiyuka.bvh",
        "../data/bvhfiles/nocchi.bvh",
      ].map do |f|
        Dancer.new(File.expand_path(f, File.dirname(__FILE__)))
      end
      loop {
        dancers.map(&:move)
        sleep 0.025
        return if dancers.first.finished?
        screen.update_rect(0, 0, WIDTH, HEIGHT)
        screen.fill_rect(0, 0, WIDTH, HEIGHT, Color::BLACK)
      }
    end
  end
end
