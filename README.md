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

Right now Shoebill uses really simple file-based, json format, read-only system to store your data.
To use it, just put your json files in 'db/links' directory. The name of the file must be the id
of the model, eg. 1.json. FileModel class is responsible to find single model or all models. You have
two methods to your disposal in controller:

    single_model = FileModel.find(id) # returns single model

    all_models = FileModel.find_all # returns the array of models

FileModel is not very powerful and it will be changed in near future.

### Controller

Create your controllers in 'app/controller' directory. The name convention for controllers is the same as in Ruby on Rails.
For file name, you should use snake_case convention. Name of the controller should be a noun in plural and postfix '_controller'.
Examples of correct names of the controllers:

    links_controller.rb
    posts_controller.rb

Your own class controller should inherit from Shoebill::Controller.

    class MyController < Shoebill::Controller
    end



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
