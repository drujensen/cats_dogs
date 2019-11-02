require "magickwand-crystal"

LibMagick.magickWandGenesis
wand = LibMagick.newMagickWand

if LibMagick.magickReadImage(wand, "./test.jpg")
  p LibMagick.magickGetImageType wand
  LibMagick.magickSetImageType wand, LibMagick::ImageType::GrayscaleType
  LibMagick.magickSetImageDepth wand, 8
  LibMagick.magickWriteImage wand, "grayscale.jpg"
end

if LibMagick.magickReadImage wand, "./grayscale.jpg"
  p LibMagick.magickGetImageType wand
  p LibMagick.magickGetImageColorspace wand
end
LibMagick.destroyMagickWand wand
LibMagick.magickWandTerminus
