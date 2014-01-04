# Shoebill

A Rack-based framework, but with extra, custom solutions and magic. Shoebill is MVC framework, with
views, controllers and models solid structure.

## Installation

Add this line to your application's Gemfile:

    gem 'shoebill'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shoebill

## Usage

### Model

Right now Shoebill uses SQLite database as default. It supports basics operations on database.
To use them, create model class that inherits from Shoebill::Model::SQLite.

    class Post < Shoebill::Model::SQLite
    end

Then you can use the following operations on the database:

    # create new model
    Post.create { title: 'Lorem ipsum', content: 'Lorem lorem' }

    # find model by id
    Post.find 1

    # find model by any attribute
    Post.find_by_title 'Lorem ipsum'

    # save model
    post = Post.find 1
    post.title = 'Some new title'
    post.save

    # count records in the table
    Post.count

    # removes record from database
    post = Post.find 1
    post.destroy



### Controller

Create your controllers in 'app/controller' directory. The name convention for controllers is the same as in Ruby on Rails.
For file name, you should use snake_case convention. Name of the controller should be a noun in plural and postfix '_controller'.
Examples of correct names of the controllers:

    links_controller.rb
    posts_controller.rb

Your own class controller should inherit from Shoebill::Controller.

    class MyController < Shoebill::Controller
    end

All instance variables, set in the controller, are available in the view templates. For example:

    class MyController < Shoebill::Controller

        def show
          @item = MyModel.find(param['id'])
        end

    end

    # in .html.erb template you can use @item variable

    <%= @item %>


## Documentation

To generate detailed documentation, make in the console:

    rdoc

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
