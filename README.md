# Sipper

Downloader for [Elixir Sips](http://elixirsips.com/).

Implemented in Elixir for fun and learning, and because the technology is well-suited to concurrent tasks.


## Usage

    mix deps.get
    mix escript.build  # Builds a "sipper" binary
    ./sipper

It will prompt for auth details and store them in `~/.elixir_sips`.


## License

By Henrik Nyh 2015-09-17 under the MIT license.
