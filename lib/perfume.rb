require 'sdl'
require 'gl'
require_relative "perfume/vector3d"
require_relative "perfume/dancer"

include Gl

class Perfume
  WIDTH = 800
  HEIGHT = 400

  class << self
    def play
      SDL.init SDL::INIT_VIDEO
      SDL::GL.set_attr SDL::GL_RED_SIZE,5
      SDL::GL.set_attr SDL::GL_GREEN_SIZE,5
      SDL::GL.set_attr SDL::GL_BLUE_SIZE,5
      SDL::GL.set_attr SDL::GL_DEPTH_SIZE,16
      SDL::GL.set_attr SDL::GL_DOUBLEBUFFER,1
      SDL::Screen.open 600,600,16,SDL::OPENGL

      glViewport( 0, 0, 600, 600 );
      glMatrixMode( GL_PROJECTION );
      glFrustum(-1.0, 1.0, -1.0, 1.0, 3.0, 10000.0);
      glLoadIdentity( );

      glMatrixMode( GL_MODELVIEW );
      glLoadIdentity( );


      dancers = [
        "../data/bvhfiles/aachan.bvh",
        "../data/bvhfiles/kashiyuka.bvh",
        "../data/bvhfiles/nocchi.bvh",
      ].map do |f|
        Dancer.new(File.expand_path(f, File.dirname(__FILE__)))
      end
      loop {
        glClearColor(0.0, 0.0, 0.0, 1.0);
        glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
        dancers.map(&:move)
        SDL::GL.swap_buffers
        sleep 0.025
        return if dancers.first.finished?
      }
    end
  end
end
