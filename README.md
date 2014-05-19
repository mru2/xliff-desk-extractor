## Setting up

```
cp .env.sample .env
nano .env 
bundle install
```


# Export the french translations

```
ruby ./export.rb
```

# Import translations

```
ruby ./import.rb <locale> <path_to_translations_file.xlf>
```


## Console

```
./console
```
