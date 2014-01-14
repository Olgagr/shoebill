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

    # update model
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

# Views

All views should be put in views/controller_name (in plural form, without controller prefix) directory. Let's say you have controller *LinksController*. In this situation
all your views for this controller should be placed in *views/links* directory.

By default, Shoebill render the view, which has the same name as action in controller. You can also render other view for particular action in controller.
If you like so, you have to say explicitly, which view should be rendered.

    class PostsController

        def show
           @post = Post.find 1
           render :post         # this will render view in file post.html.erb
        end
    end

All instance variable, which are set in controller action, are automatically available in the view.

    class PostsController

        def show
           @post = Post.find 1
           @author = Author.find 1
        end
    end

Views in Shoebill, use ERB templating system. See more: http://apidock.com/ruby/ERB



## Documentation

To generate detailed documentation, make in the console:

    rdoc

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
