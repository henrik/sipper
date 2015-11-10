# Sipper

[![Build Status](https://travis-ci.org/henrik/sipper.svg?branch=master)](https://travis-ci.org/henrik/sipper)

Downloader for [Elixir Sips](http://elixirsips.com/), implemented in Elixir for fun and learning.

![Screenshot](https://s3.amazonaws.com/f.cl.ly/items/2D1L0x0e1d2D2x2L3D3o/sipper.gif)


## Usage

You need a paid account with [Elixir Sips](http://elixirsips.com/). Then build the downloader and run it.

### Building

Clone this repo and:

    mix deps.get
    mix escript.build  # (or just "mix": this is the default task)

This builds a `sipper` executable in the current directory.

The `sipper` executable is self-contained and can run on any machine with Erlang installed. [Read more.](http://elixir-lang.org/docs/master/mix/Mix.Tasks.Escript.Build.html)

### Downloading

Now you can download episodes with:

    ./sipper --user me@example.com --pw mypassword

If you want to limit the download to e.g. the last 3 episodes, do:

    ./sipper --user me@example.com --pw mypassword --max 3

You may also want start downloading from very beginning. To do so:

     ./sipper --user me@example.com --pw mypassword --oldest-first

By default, files end up in `./downloads`. You can specify another destination (automatically created if it doesn't exist):

    ./sipper --user me@example.com --pw mypassword --dir ~/Downloads/Elixir\ Sips

If a file exists on disk, it won't be downloaded again.

#### Saved configuration

If you don't want to specify these parameters each time, you can put them in a `~/.sipper` file, containing e.g.

    --user me@example.com --pw mypassword --dir ~/Downloads/Elixir\ Sips

Then you can just run the app like:

    ./sipper

Assuming you've created `~/.sipper` file with the configuration above, you may also pass more command-line args:

    ./sipper --oldest-first --max 3 --dir ~/Videos/Elixir\ Sips

So, even if you had `--dir ~/Downloads/Elixir\ Sips` in your `~/.sipper` file, the `--dir ~/Videos/Elixir\ Sips` arguments will have
preference over it.


## Don't be evil

Be kind: only download for personal use.


## Also see

* [Elixir Sips Downloader](https://github.com/benjamintanweihao/elixir-sips-downloader) written in Ruby
* [elixirsips-downloader](https://github.com/christian-fei/elixirsips-downloader) written in JavaScript


## License

By Henrik Nyh 2015-09-17 under the MIT license.
