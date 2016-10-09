![docker_build_type](https://img.shields.io/docker/automated/frankke/mersea.svg)
![license](https://img.shields.io/dub/l/vibe-d.svg)

# Mersea

## Requirements

- MRI 2.3.x
- Postgres 9.5 [configuration file](https://github.com/FranckKe/mersea/blob/master/config/database.yml)

## Create an admin account

Within a Rails console:
```rb
Admin.create(name: 'ANSEL', email: 'asso-ansel@club-internet.fr', password: 'strongpassword')
```

## Development

```sh
# Install and configure db
$ bundle install
$ bundle exec rails db:create
$ bundle exec rails db:migrate

# Launch app
$ bundle exec rails s
```

## Production with Docker

- Start Postgres server
```sh
$ docker run --name postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres:latest
```

- Create/migrate database
```sh
$ docker run --rm \
  -e MERSEA_DATABASE_HOST=192.168.20.42 \
  -e MERSEA_DATABASE_PORT=5432 \
  -e MERSEA_DATABASE_USERNAME=postgres \
  -e MERSEA_DATABASE_PASSWORD=postgres \
  -it franckke/mersea:latest bundle exec rake db:create

$ docker run --rm \
  -e MERSEA_DATABASE_HOST=192.168.20.42 \
  -e MERSEA_DATABASE_PORT=5432 \
  -e MERSEA_DATABASE_USERNAME=postgres \
  -e MERSEA_DATABASE_PASSWORD=postgres \
  -it franckke/mersea:latest bundle exec rake db:migrate
```

- Start BreizhTrip
```sh
$ docker run --name breizhtrip \
  -e MERSEA_DATABASE_HOST=192.168.20.42 \
  -e MERSEA_DATABASE_PORT=5432 \
  -e MERSEA_DATABASE_USERNAME=postgres \
  -e MERSEA_DATABASE_PASSWORD=postgres \
  -e RAILS_SERVE_STATIC_FILES=true \
  -p 3000:3000 -d franckke/mersea:latest

# or with linked Postgres server container
$ docker run --name breizhtrip \
  --link postgres:psqlhost \
  -e MERSEA_DATABASE_HOST=psqlhost \
  -e MERSEA_DATABASE_PORT=5432 \
  -e MERSEA_DATABASE_USERNAME=postgres \
  -e MERSEA_DATABASE_PASSWORD=postgres \
  -e RAILS_SERVE_STATIC_FILES=true \
  -p 3000:3000 -d franckke/mersea:latest
```
To set any environment variable in the container, use one or more `-e` flags:
- `MERSEA_NAMESPACE` → namespace the url
- `RAILS_SERVE_STATIC_FILES` → the webapp serves all the assets instead of NGINX
- `MERSEA_DATABASE_POOL` → database connection pool size
- `MERSEA_DATABASE_HOST` → database host (IP address or URL)
- `MERSEA_DATABASE_PORT` → database port (by default 5432)
- `MERSEA_DATABASE_USERNAME` → database credential
- `MERSEA_DATABASE_PASSWORD` → database credential

## License

MIT. See the [LICENSE](https://github.com/FranckKe/mersea/blob/master/LICENSE) for more details.

## Contributing

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Ensure specs and Rubocop pass
5. Push to the branch (git push origin my-new-feature)
6. Create new Pull Request
