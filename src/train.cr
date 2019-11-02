require "shainet"
require "./cats_dogs/*"

outcome = {
  "cat" => [1.0, 0.0],
  "dog" => [0.0, 1.0],
}

# data structures to hold the input and results
inputs = Array(Array(Float64)).new
outputs = Array(Array(Float64)).new

# load images
["cat", "dog"].each do |type|
  files = Dir["./train/#{type}.*.png"]

  files.each do |file_name|
    image = Image.new(file_name)
    row_arr = Array(Float64).new
    (0...image.height).each do |y|
      (0...image.width).each do |x|
        value = image.grey_scale(x, y)
        row_arr << value
      end
    end
    inputs << row_arr
    outputs << outcome[type]
  end
end

training = SHAInet::CNNData.new(inputs, outputs)
training.data_pairs.shuffle!

model = SHAInet::CNN.new
model.add_input([height = 48, width = 48, channels = 1])

model.add_conv(
  filters_num: 20,
  window_size: 3,
  stride: 1,
  padding: 1,
  activation_function: SHAInet.none)
model.add_maxpool(pool: 2, stride: 2)

model.add_conv(
  filters_num: 20,
  window_size: 3,
  stride: 1,
  padding: 1,
  activation_function: SHAInet.none)
model.add_maxpool(pool: 2, stride: 2)

model.add_fconnect(l_size: 12, activation_function: SHAInet.sigmoid)

# optimization settings
model.learning_rate = 0.005
model.momentum = 0.02

model.inspect(:dimensions)

# train the network
model.train_batch(
  data: training.data_pairs,
  training_type: :sgdm,
  cost_function: :mse,
  epochs: 25,
  error_threshold: 0.0001,
  log_each: 100,
  mini_batch_size: 32)

# model.save_to_file("./network/model.nn")

correct_answers = 0
training.data_pairs.each do |data_point|
  result = model.run(data_point[:input], stealth: true)
  if (result.index(result.max) == data_point[:output].index(data_point[:output].max))
    correct_answers += 1
  end
end

# Print the layer activations
# model.inspect("activations")
# puts "We managed #{correct_answers} out of #{training.data_pairs.size} total"
# puts "Cnn output: #{model.output}"
