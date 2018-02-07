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



## Usage

Once installed, you can begin using the plugin by typing:

```
nib integrate init
```

Initialization creates a `.nib-integrate-config` file in your home directory.
The init step must be done before any of the other commands will work.

To register app1 from above for use with `nib-integrate`:

```
nib integrate register -a app1 -p /path/to/src/app1 -s web
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

## Under The Hood

When the up command is run, a dynamically generated integration file is
generated. This file puts the service container in the default network
and the nib-integrate-network. and provides an external link to all other
registered services. This file is then passed as an additional configuration
file to the docker-compose command that is generated when `up` is called.

```
# app1/docker-compose-integration.yml

services:
  web:
    external_links:
      - myexternalservice_web_1:myexternalservice_web
    networks:
      - default
      - outside
networks:
  outside:
    external:
      name: nib-integrate-network
```


## Development

Development is done using a docker environment. Run `nib rspec gem` to ensure
specs are passing, and then changes can be made.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/nib-integrate.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
