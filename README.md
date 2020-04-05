# Sp33d3rR

Ruby web scraper to search url files from Bing.

## General information

Tested only on macOS Catalina, it should work on Linux.

### Prerequisites

Required gems:

```
benchmark, nokogiri, open-uri, optparse, pastel
```

### Installing

If you are using macOS, the way to install the gems one by one is like this:

```
sudo gem install nokogiri
```

### How to use

Open Terminal app or other console app and execute:

```
ruby sp33d3rr.rb -s apple.com
```

By default the program prints only urls but you can also print the file title, like this:

```
ruby sp33d3rr.rb -s apple.com -b
```

To see the available options run:

```
ruby sp33d3rr.rb -h
```

## Built With

* ruby 2.6.3p62 (2019-04-16 revision 67580) [universal.x86_64-darwin19]

## Authors

* **Jonathan Burgos Saldivia** - *on Github* - [jonathanburgossaldivia](https://github.com/jonathanburgossaldivia)

## License

This project is licensed under the Eclipse Public License 2.0 - see the [LICENSE.md](LICENSE.md) file for details
