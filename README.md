## Setting up

```
cp .env.sample .env
nano .env 
bundle install
```


## Usage

### Import all the existing desk translations in .yml files, for uploading to localeapp

```
rake export_to_yaml
```

### Update the desk articles and topics with the latest translations from localeapp

```
rake sync_translations
```


## Console

```
./console
```
