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

By default, episodes are downloaded newest-first. If you want to instead download them oldest-first, do:

    ./sipper --user me@example.com --pw mypassword --oldest-first

If you want to ignore some episodes (e.g. deprecated content), do:

    ./sipper --user me@example.com --pw mypassword --ignore "007,008,009"
    
You may want to start downloading from N, do:

    ./sipper --user me@example.com --pw mypassword --oldest-first --start N

By default, files end up in `./downloads`. You can specify another destination (automatically created if it doesn't exist):

    ./sipper --user me@example.com --pw mypassword --dir ~/Downloads/Elixir\ Sips

If a file exists on disk, it won't be downloaded again.

#### Saved configuration

If you don't want to specify these parameters each time, you can put them in a `~/.sipper` file, containing e.g.

    --user me@example.com --pw mypassword --dir ~/Downloads/Elixir\ Sips

Then you can just run the app like:

    ./sipper


## Don't be evil

Be kind: only download for personal use.


## Also see

* [Elixir Sips Downloader](https://github.com/benjamintanweihao/elixir-sips-downloader) written in Ruby
* [elixirsips-downloader](https://github.com/christian-fei/elixirsips-downloader) written in JavaScript

## Miscellaneous
* This can also be used for RubyTapas, just change the `@subdomain` to `rubytapas` and run `mix` to recompile.

## License

By Henrik Nyh 2015-09-17 under the MIT license.
