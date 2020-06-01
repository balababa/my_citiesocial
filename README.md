# My_citiesocial
A project designed based on [Citiesocial](https://www.citiesocial.com/) for practicing RoR.
The project is originally created by [Eddie Kao](https://github.com/kaochenlong/my-citiesocial)

Logo 版權屬 Citiesocial 所有
## Prerequisites
The setups steps expect following tools installed on the system.

- Git
- Ruby 2.6.3
- Rails 6.0.0.2
- Yarn
- NodeJs
- Postgresql

## Packages / Toos
* [devise](https://github.com/heartcombo/devise): Framework for authentication and easily generating member system
* [Bulma](https://github.com/jgthms/bulma): CSS framework
* [AASM](https://github.com/aasm/aasm): State machine, make model fat and controller skinny by defining state and event in models.
* [friendly_id](https://github.com/norman/friendly_id): Beautify url or SEO by changing slug to human-friendly string(e.g. story title)
* [webpacker](https://github.com/rails/webpacker): Asssets bundler
* [stimulusJS](https://chloerei.com/2018/02/24/stimulus/): JS framework for UJS working well with turbolinks
* [foreman](https://github.com/theforeman/foreman): Quickly deploy  application by defining processes and jobs in `Procfile`
* [paranoia](https://github.com/rubysherpas/paranoia): Implementation of soft delete by add new column `deleted_at` to model and overide `delete` and `destroy` 
* [yarn](https://github.com/yarnpkg/yarn): Package manager for JS
* [Froala](https://github.com/froala/wysiwyg-editor): Embedded WYSIWYG text editor
* [figaro](https://github.com/laserlemon/figaro): Git-ignored application configuration defined in `config/application.yml`
* [Faraday](https://github.com/lostisland/faraday): HTTP client library
*  [Pagy](https://github.com/ddnexus/pagy): Gem for pagination
*  [acts_as_list](https://github.com/brendon/acts_as_list): Sort and reorder model objects like list
*  [Sortable](https://github.com/SortableJS/Sortable): JS library making elements like div or list draggable
*  [rspec-rails](https://github.com/rspec/rspec-rails): Testing library
*  [faker](https://github.com/faker-ruby/faker): Library for generating fake data
*  [timecop](https://github.com/travisjeffery/timecop): Gem for simulating system time
*  [trix](https://github.com/basecamp/trix): WYSIWYG editor made by basecamp
## Installation

### 1. Check out the repository

```bash
git clone git@github.com:balababa/my_citiesocial.git
```
### 2. Create application.yml file

```bash
cp config/application.yml.sample config/application.yml
```
> set the environment variables needed in application.yml.

### 3. Create and setup the database

Run the following commands to create and setup the database.

```ruby
bin/rails db:create
bin/rails db:migrate
```
> You may need to set up database configuration in `config/database.yml`

### 4. Start the Rails server

```ruby
bin/rails s
```
You also need to start webpack-dev-server in a separate terminal to watch for changes in `app/javascript/packs/*.js` and compile it immediately.
```ruby
bin/webpack-dev-server
```


---

Or you can start all processes and jobs needed to run by
```ruby
foreman start 
```
> The processes are defined in `~/Procfile`
