# Sipper

Downloader for [Elixir Sips](http://elixirsips.com/), implemented in Elixir for fun and learning.

![Screenshot](https://s3.amazonaws.com/f.cl.ly/items/2A1I0V1P3Y2o3x3u2F3F/Screenshot%202015-09-19%2009.49.43.png)


## Usage

You need a paid account with Elixir Sips. Then clone this repo and:

    mix deps.get
    mix escript.build  # Builds a "sipper" executable
    ./sipper --user me@example.com --pw mypassword

If you want to limit the download to e.g. the last 3 episodes, do:

    ./sipper --user me@example.com --pw mypassword --max 3

Files will end up in `./downloads`. If a file exists on disk, it won't be downloaded again.

Be kind and only download for personal use.


## License

By Henrik Nyh 2015-09-17 under the MIT license.
