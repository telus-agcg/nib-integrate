# nib-integrate

This nib plugin is designed to enable quick up and down of services that rely
on one another to work correctly. This gem will rely on a common network
having already been defined and the `docker-compose.yml` file or another
integration `yml` file putting the containers in the right network.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nib-integrate'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nib-integrate

## Prerequisites

You must have `nib` version `>= 2` in order for this plugin to work.

Your applications must also have docker-compose configuration that allows
the containers to exist on the same network as containers in other projects.

This is accomplished by using the `docker network` settings available in
docker-compose.

Here is a sample configuration for external networking for a docker-compose
service. Let's assume that the web service has been defined in the
`docker-compose.yml` file.

```
# app1/docker-compose-integration.yml

services:
  web:
    external_links:
      - myexternalservice_web_1:ex-1
    networks:
      - default
      - outside
networks:
  outside:
    external:
      name: inter-service-network
```

In this example, the "inter-service-network" will have been created by this command:

```
docker network create inter-service-network
```

In the external service docker-compose.yml file, the following configuration
would exist:

```
# external_service/docker-compose.yml


services:
  web:
    networks:
      - default
      - outside
networks:
  outside:
    external:
      name: inter-service-network
```

## Usage

Once installed, you can begin using the plugin by typing:

```
nib integrate init
```

Initialization creates a `.nib-integrate-config` file in your home directory.
The init step must be done before any of the other commands will work.

To register app1 from above for use with `nib-integrate`:

```
nib integrate register -a app1 -p /path/to/src/app1 -s web -i docker-compose-integration.yml
```

To register external_service from above for use with `nib-integrate`:

```
nib integrate register -a external_service -p /path/to/src/external_service -s web
```

The external service's network configuration is in its `docker-compose.yml` file
so you don't need to specify an integration file (`-i`) when registering the app

To bring both of these services up in the background and have them communicate
together over the `inter-service-network`:

```
nib integrate up app1 external_service
```

To stop them both at the same time:

```
nib integrate down app1 external_service
```

To list registered services:

```
nib integrate list
```

## Development

Development is done using a docker environment. Run `nib rspec gem` to ensure
specs are passing, and then changes can be made.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/nib-integrate.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
