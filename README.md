# Bullhorn

_Get your message out_

A microservice dedicated to handling outgoing notifications across email, SMS, and other mediums.

## Setup

Elixir & Erlang versions are defined in `.tool-versions` and can be installed with [asdf](https://asdf-vm.com/).
Bullhorn consumes [Bottle](https://github.com/system76/bottle) messages from RabbitMQ, and sends appropriate messages out to 3rd parties providers (Mailgun/Twilio).
These dependencies can be configured through `dev.exs` for local environments.
 
The application is started with `mix run` or as an interactive session with `iex -S mix run`.
