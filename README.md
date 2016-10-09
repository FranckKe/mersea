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

- Start server via Docker Compose
```sh
$ cd /path/to/mersea
$ docker-compose up -d
```

http://localhost:3000

- Start a Rails console
```sh
# mersea_mersea_1 is the container name defined by docker-compose
$ docker exec -it mersea_mersea_1 bundle exec rails c
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
