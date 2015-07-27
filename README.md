## Installation

* `gem install fringe`
* `fringe new app`
* `cd app`
* `bundle`
* `rackup`

## Example

*HelloWorldController* `app/controllers/hello_world_controller.rb`
```
class HelloWorldController < Fringe::BaseController
  def greeting
    [
      200,
      {'Content-Type' => 'text/plain'},
      [
        'Hello, World!'
      ]
    ]
  end
end
```

*Routes* `app/routes.rb`
```
module Routes
  extend Fringe::RouteHelpers
  get(/\/greet/i, HelloWorldController, :greeting)
end
```
start the app!
`rackup`

```
> curl http://localhost:9292/greet
Hello, World!
```


## License
Fringe is released under the [MIT License](http://www.opensource.org/licenses/MIT).
