class LargeCoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  procee :resize_to_fill => [665, 375]
end