
# Adidas Scraper

I am a tall person and it is kind of hard to find long enough trausers. So I wrote a simple app that will help me in doing that


## Usage/Examples

Running following script will output links to products that are either:

1. not subscribed to email notification when a size will enter the store
2. url is explicitly ignored
3. url contains a keyword that is ignored

```bash
bundle exec ruby crawler.rb
```


## Features

- Ignoring products by whole url
- Ignoring products by a keyword from url
- Ignoring products that are already in subscribed to a notification when a size will enter the store

