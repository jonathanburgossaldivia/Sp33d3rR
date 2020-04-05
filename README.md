# Sp33d3rR

Web scraper to search url files from Bing

## Getting Started

Tested only on macOS Catalina, it should work on Linux.

### Prerequisites

required gems

```
benchmark, nokogiri, open-uri, optparse, pastel
```

### Installing

If you are using macOS, the way to install the gems one by one is like this:

```
sudo gem install nokogiri
```

Once the installation of the gems is finished, you can go to the next step

## Running the tests

Explain how to run the automated tests for this system

### Before starting

Open Terminal app or other console app and execute:

```
ruby sp33d3rr.rb -s apple.com
```

### And coding style tests

By default the program prints only urls but you can also print the file title, like this:

```
ruby sp33d3rr.rb -s apple.com -b
```

## Built With

* ruby 2.6.3p62 (2019-04-16 revision 67580) [universal.x86_64-darwin19]

## Authors

* **Jonathan Burgos Saldivia** - *on Github* - [jonathanburgossaldivia](https://github.com/jonathanburgossaldivia)

## License

This project is licensed under the Eclipse License - see the [LICENSE.md](LICENSE.md) file for details
