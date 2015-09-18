# Sipper

**Work in progress! Status per 2015-09-18 11:10:** Works but is very unpolished.

Downloader for [Elixir Sips](http://elixirsips.com/).

Implemented in Elixir for fun and learning, and because the technology is well-suited to concurrent tasks.


## Usage

You need a paid account with Elixir Sips. Then clone this repo and:

    mix deps.get
    mix escript.build  # Builds a "sipper" binary
    ./sipper --user me@example.com --pw mypassword

If you want to limit the download to e.g. the last 3 episodes, do:

    ./sipper --user me@example.com --pw mypassword --max 3

Files will end up in `./downloads`. If a file exists on disk, it won't be downloaded again.

Be kind and only download for personal use.


## License

By Henrik Nyh 2015-09-17 under the MIT license.
