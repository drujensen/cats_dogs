# cats_dogs

WIP

Cats vs Dogs Kaggle Competition using Crystal and NeuraLegion's ShaiNet library

## Installation

Install crystal and run `shards install` to install the shards
Download the training data and unzip in the root directory of the project.

https://www.kaggle.com/c/dogs-vs-cats-redux-kernels-edition/data

## Usage

run `crystal src/convert.cr` to convert the training images to 50x50 greyscale

To build and run using threads:
```
crystal build -Dpreview_mt --release src/train.cr -o ./bin/train
CRYSTAL_WORKERS=16 ./bin/train
```

## Contributing

1. Fork it ( https://github.com/drujensen/cats_dogs/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [drujensen](https://github.com/drujensen) Dru Jensen - creator, maintainer
