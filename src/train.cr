require "shainet"
require "./cats_dogs/*"

outcome = {
  "cat" => [1.0, 0.0],
  "dog" => [0.0, 1.0],
}

# data structures to hold the input and results
# Images / Channels / Rows / Columns / value
inputs = Array(Array(Array(Array(Float64)))).new
outputs = Array(Array(Float64)).new

# load images
["cat", "dog"].each do |type|
  files = Dir["./train/#{type}.*.png"]

  files.each do |file_name|
    image = Image.new(file_name)
    channel_arr = Array(Array(Array(Float64))).new
    (0..2).each do |c|
      row_arr = Array(Array(Float64)).new
      (0...image.height).each do |y|
        col_arr = Array(Float64).new
        (0...image.width).each do |x|
          col_arr << image.data(x, y)[c]
        end
        row_arr << col_arr
      end
      channel_arr << row_arr
    end
    inputs << channel_arr
    outputs << outcome[type]
  end
end

alias Pair = {input: Array(Array(Array(Float64))), output: Array(Float64)}

data_pairs = Array(Pair).new
inputs.each_with_index do |input, i|
  data_pairs << {input: input, output: outputs[i]}
end

model = SHAInet::CNN.new
model.add_input([height = 48, width = 48, channels = 3])

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

model.add_fconnect(l_size: 12, activation_function: SHAInet.relu)

model.add_fconnect(l_size: 2, activation_function: SHAInet.sigmoid)

model.add_softmax

model.inspect :dimensions

# optimization settings
model.learning_rate = 0.005
model.momentum = 0.02

# train the network
model.train_batch(
  data: data_pairs,
  training_type: :adam,
  cost_function: :mse,
  epochs: 3,
  error_threshold: 0.0001,
  log_each: 1,
  mini_batch_size: 100)

# model.save_to_file("./network/model.nn")

# determine accuracy
tn = tp = fn = fp = 0

inputs.each_with_index do |test, idx|
  results = model.run(test)
  if results[0] < 0.5
    if outputs[idx][0] == 0.0
      tn += 1
    else
      fn += 1
    end
  else
    if outputs[idx][0] == 0.0
      fp += 1
    else
      tp += 1
    end
  end
end

puts "Training size: #{outputs.size}"
puts "----------------------"
puts "TN: #{tn} | FP: #{fp}"
puts "----------------------"
puts "FN: #{fn} | TP: #{tp}"
puts "----------------------"
puts "Accuracy: #{(tn + tp) / outputs.size.to_f}"
