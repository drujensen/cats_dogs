require "stumpy_png"

class Image
  include StumpyPNG

  property canvas : Canvas

  def initialize(@file_name : String)
    @canvas = StumpyPNG.read(@file_name)
  end

  def name
    @file_name.split("/")[3]
  end

  def width
    @canvas.width
  end

  def height
    @canvas.height
  end

  def data(x : Int32, y : Int32)
    r, g, b = @canvas.[x, y].to_rgb8
    return [r.to_f, g.to_f, b.to_f]
  end

  def grey_scale(x : Int32, y : Int32)
    r, g, b = @canvas.[x, y].to_rgb8
    return (r.to_f + g.to_f + b.to_f) / 3
  end
end
