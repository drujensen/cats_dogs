require "magickwand-crystal"

LibMagick.magickWandGenesis
wand = LibMagick.newMagickWand

["cat", "dog"].each do |type|
  files = Dir["./test/#{type}.*.jpg"]

  files.each do |file_name|
    puts "reading #{file_name}"
    if LibMagick.magickReadImage(wand, file_name)
      LibMagick.magickSetImageType wand, LibMagick::ImageType::GrayscaleType
      LibMagick.magickSetImageDepth wand, 8
      LibMagick.magickScaleImage wand, 48, 48

      new_name = "#{file_name.not_nil![0...-4]}.png"
      puts "writing #{new_name}"
      LibMagick.magickWriteImage wand, new_name
    end
  end
end

LibMagick.destroyMagickWand wand
LibMagick.magickWandTerminus
