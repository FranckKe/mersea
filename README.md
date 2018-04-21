![docker_build_type](https://img.shields.io/docker/automated/franckke/mersea.svg)
![license](https://img.shields.io/dub/l/vibe-d.svg)

# Mersea

## Requirements

- MRI 2.5.x
- Postgres 9.5 [configuration file](https://github.com/FranckKe/mersea/blob/master/config/database.yml)

## Create an admin account

Within a Rails console:
```rb
Admin.create(name: 'myname', email: 'myemail@email.local', password: 'mypassword')
```


## Development

```sh
# Install and configure db
$ bundle install
$ bundle exec rails db:create
$ bundle exec rails db:migrate

# Add static pages
$ bundle exec rails db:seed

# Launch app
$ bundle exec rails s
```

Configure your reCaptcha keys.

## Production with Docker

**Configure your reCaptcha keys as environment variables**

- Start server via Docker Compose
```sh
$ cd /path/to/mersea
$ docker-compose up -d
```
> Feel free to modifies the provided docker-compose.yml to your needs.

http://localhost:3000

- Start a Rails console
```sh
# mersea_mersea_1 is the container name defined by docker-compose
$ docker exec -it mersea_mersea_1 bundle exec rails c
```

To set any environment variable in the container, use one or more `-e` flags:
- `JWT_SECRET` → the JWT secret
- `MERSEA_NAMESPACE` → namespace the url
- `RAILS_SERVE_STATIC_FILES` → the webapp serves all the assets instead of NGINX
- `MERSEA_DATABASE_POOL` → database connection pool size
- `MERSEA_DATABASE_HOST` → database host (IP address or URL)
- `MERSEA_DATABASE_PORT` → database port (by default 5432)
- `MERSEA_DATABASE_USERNAME` → database credential
- `MERSEA_DATABASE_PASSWORD` → database credential
- `RECAPTCHA_SITE_KEY` → Google reCaptcha key
- `RECAPTCHA_SECRET_KEY` → Google reCaptcha secret
- `BUGSNAG_API_KEY` → Bugsnag key (leave empty to disable error reporting)

## License

MIT. See the [LICENSE](https://github.com/FranckKe/mersea/blob/master/LICENSE) for more details.

## About
- An application created for [ANSEL](https://www.assoansel.com/) at the [Ocean Hackathon](http://www.seatechevent.eu/Temps-forts-Ocean-Hackathon-_7-au-9-octobre-2016_-696-17-0-0.html)
- TV News Story on Tébéo, [video@8:30](http://www.tebeo.bzh/replay/23-jt/9478685)

## Contributing

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Ensure specs and Rubocop pass
5. Push to the branch (git push origin my-new-feature)
6. Create new Pull Request
