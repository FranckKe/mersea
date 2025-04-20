# Mersea

![license](https://img.shields.io/dub/l/vibe-d.svg)

## Requirements

- Ruby MRI 3.2.x ([rbenv](https://github.com/rbenv/rbenv) recommended)
- Bundler
- Rails 6.x
- Postgres 16+ [configuration file](https://github.com/FranckKe/mersea/blob/master/config/database.yml)
- [ImageMagick](https://www.imagemagick.org/script/index.php)(for thumbnails)

### Setup

```sh
# sudo apt install git curl libssl-dev libreadline-dev zlib1g-dev autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev libpq-dev rbenv

# If first time setup
git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
# else

git -C "$(rbenv root)"/plugins/ruby-build pull # Update when needed

# Add to shell
# echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
# echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc

rbenv install
rbenv local
gem install bundler
# If error "You don't have write permissions for the /var/lib/gems/3.0.0 directory."
# source ~/.bash_profile or source ~/.zshrc
```

## Development

Clone repository.

```sh
# Install and configure db
bundle install
mkdir data
chown -R 1000:1000
docker stop mersea_postgres; docker rm mersea_postgres; docker run -d \
  --name mersea_benji_postgres \
  -p 127.0.0.1:5432:5432 \
  --user 1000:1000 \
  -e POSTGRES_PASSWORD=postgres \
  -e PGDATA=/var/lib/postgresql/data/pgdata \
  -v $(pwd)/data/db:/var/lib/postgresql/data/pgdata \
  --restart always \
  postgres:17-alpine
bundle exec rails db:create
bundle exec rails db:migrate

# Add static pages
bundle exec rails db:seed

# Launch app
bundle exec rails s
```

[Increase inotify watchers](https://github.com/guard/listen/wiki/Increasing-the-amount-of-inotify-watchers).

ReCaptcha is disabled in development. Configure key if needed using `RECAPTCHA_SECRET_KEY` and `RECAPTCHA_SITE_KEY`.

### Create an admin account

Within a Rails console:

```sh
bundle exec rails console
```

```rb
Admin.create(name: 'myname', email: 'myemail@email.local', password: 'mypassword')
```

Admin section is reachable at `/admin`.

### Frontend

To setup frontend, see readme in `./frontend`.

## Production with Docker

Configure your reCaptcha keys as environment variables

- Start server via Docker Compose

```sh
cd /path/to/mersea
docker-compose up -d
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

## Datagouv export

```sh
# Configure .env file with datagouv credentials
bundle exec rake datagouv
```

## License

MIT. See the [LICENSE](https://github.com/FranckKe/mersea/blob/master/LICENSE) for more details.

## About

- [For more information about the project checkout the about and information section on oceanplastictracker.com](https://oceanplastictracker.com)

## Contributing

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Ensure specs and Rubocop pass
5. Push to the branch (git push origin my-new-feature)
6. Create new Pull Request

## Special thanks

We would like to thanks the following companies for their open source plans and support

|                                                                                |                                                                                                                                                |
| :----------------------------------------------------------------------------: | :--------------------------------------------------------------------------------------------------------------------------------------------- |
|        [![Bugsnag](thanks_logos/bugsnagx128.png)](https://bugsnag.com)         | Thanks to **Bugsnag** we can monitor and investigate errors on our application                                                                 |
|          [![Mapbox](thanks_logos/mapboxx128.png)](https://mapbox.com)          | Thank you to **Mapbox** for their mapping services and tools                                                                                   |
| [![BrowserStack](thanks_logos/browserstackx128.png)](https://browserstack.com) | Thank you to **BrowserStack** for their testing platform. It allows us to seamlessly test our web application on different devices and browser |
|      [![Circle-ci](thanks_logos/circlecix128.png)](https://circleci.com)       | Thanks to **Circleci** we can build efficient ci/cd pipelines                                                                                  |

Thanks to all the open source tools we are using to make our application ([gemfile](Gemfile), [package.json](front/package.json))
