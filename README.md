# Setup

Prerequisites

- [Ruby 3.3.0](https://www.ruby-lang.org/en/downloads/)
- [PostgreSQL](https://www.postgresql.org/download/)
- [Node.js 20.11.0](https://nodejs.org/en/blog/release/v20.11.0)

Create `.env` file at the root of the project directory. Copy the content of `.env.template.erb` to `.env` then update the `username` and `password` based on your database credentials

Install dependencies

```bash
bin/bundle i
```

```bash
yarn install
```

Setup database

```bash
bin/rails db:setup
```

Start local web server

```bash
bin/dev
```

# Testing

Setup test database

```bash
bin/rails db:test:prepare
```

Default: Run all spec files (i.e., those matching spec/\*\*/\*\_spec.rb)

```bash
rspec
```

Run all spec files in a single directory (recursively)

```bash
rspec spec/models
```

Run a single spec file

```bash
rspec spec/models/entrance_spec.rb
```

Run a single example from a spec file (by line number)

```bash
rspec spec/models/entrance_spec.rb:6
```

See all options for running specs

```bash
rspec --help
```

# Modules

`Dashboard` - Not implemented yet

`Entrances` - List of parking entrances

`Parking Lots` - List of parking lots. You can add slot when adding new parking lot

`Parking Slots` - List of parking slots

`Bookings` - List of vehicle bookings
