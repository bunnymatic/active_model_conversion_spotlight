# tl;dr

Easily build renderable ruby classes for Rails using `ActiveModel::Conversion`.

To make a ruby class named `SuperWidget` renderable in Rails

* add `include ActiveModel::Conversion` to the class
* add a corresponding partial in `app/super_widgets/_super_widget.html.slim`
* set it up in a controller
```
    @widget = SuperWidget.new
```
* render it in a view
```
    render @widget
```

# use `ActiveModel::Conversion` to build widgets

## the problem

In a recent project, we had several little status/info blocks that we wanted to render on a page.  Each block required a different combination of data.  In the controller, as we started writing code to fetch all the right data and put it together, we quickly realized that thing were going to get ugly.  We started with something like this:

```
# in app/controllers/pages_controller.rb
class PagesController < ApplicationController
  ...

  def welcome
    @hot_stuff = Stuff.hot.limit(5)
    @recent_activity = Activity.recent.limit(5)
    ...
  end

end
```
```
/ in app/views/pages/index.slim
.main
  section.block
    h1 this is hot
    ul.hot_stuff  
      - @hot_stuff.each do |hot|
        li = hot.snippet
  section.block
    h1 this is recent
    ul.recent_activity
      - @recent_activity.each do |recent|
        li = recent.snippet
  ... etc ...
```

You can see that as we added more items to put on the page, both the controller and view got bigger and more complex.

What we wanted was two-fold:

1. Presenters that would be used to combine the data in the right way for each block
1. An easy way to render those presenter objects

## the solution

### presenters

The first step is to build some presenters.  Using the example above, we could write two simple wrappers to manage packaging the data nicely.

```
# the hot stuff wrapper/presenter
class HotStuff
  def items
    @items ||= Stuff.hot.limit(5)
  end
end
```

And for recent activity, we could do

```
# the recent activity wrapper
class RecentActivity
  def items
    @items ||= Activity.recent.limit(5)
  end
end

```

Then we can simplify the controller method a bit.

```   
  def welcome
    @hot_stuff = HotStuff.new
    @recent_activity = RecentActivity.new
  end
```

This solves the first issue, but it has not simplified the view.  This is where `ActiveModel::Conversion` comes in.

### renderable classes

By mixing `ActiveModel::Conversion` into our wrapper classes, the classes suddenly know how to render themselves.

In both classes, we add:

```
  include ActiveModel::Conversion
```

This adds the following methods: `#to_model`, `#to_key`, `#to_param`, and `#to_partial_path` to our classes.  These methods are used by `ActionController::Base#render`.  Rendering an object like:

```
   render @object
```
is effectively doing this:

```              
    render @object.to_partial_path, :<model name> => @object
```
And `to_partial_path` generates a path that looks like `<model names>/<model name>`

Now that we've added the mixin, we can update the view:

```
/ app/pages/index.html.slim
.main
  section.block
    == render @hot_stuff
  section.block
    == render @recent_activity
```

And to finish it up, we need to add partials (whose patch is going to match `to_partial_path`'s response) for the two wrapper classes.
```
/ in app/views/hot_stuffs/_hot_stuff.slim
h1 this is hot
ul.hot_stuff  
  - @hot_stuff.items.each do |hot|
    li = hot.snippet
```
```
/ in app/views/recent_activities/_recent_activity.slim
h1 this is recent
ul.recent_activity
  - @recent_activity.each do |recent|
    li = recent.snippet
```

Now that we've got this far, we can do one more refactor:
```
  # app/controllers/pages_controller.rb
  def welcome
    @homepage_blocks = [HotStuff.new, RecentActivity.new]
  end
```
```
/ app/pages/index.html.slim
.main
  section.block
    - @homepage_blocks.each do |block|
      == render block
```

That's it.  At this point, the home page will render the two blocks, one showing hot stuff, and one showing recent activity.  The partials are (for this example) pretty dumb, but you can imagine fleshing them out to pull from other methods you might put in the wrappers (which are not unlike presenters).


## Sample App

The sample app here includes the following widgets:

* SineWave
* SquareWave
* TriangleWave
* RandomFunction
* InstagramWidget
* GithubWidget

If you look through the code, you can see how things were built, but the first four include Javascript required to get the graphs drawn.  The partial for the model handles that bit.  And the other widgets are wrappers on a thin feed puller and draw the first few (or random) entries from their respective feeds.  The controller, in this case, simply chooses a random array of these widgets and renders them.  Each page refresh, you get a new set of widgets.

# references

* [ActiveModel::Conversion](http://api.rubyonrails.org/classes/ActiveModel/Conversion.html)
* [Rails render](http://guides.rubyonrails.org/layouts_and_rendering.html#using-render)

# develop

* clone it

```
    git clone https://github.com/bunnymatic/active_model_conversion_spotlight.git
```

* bundle it

```
    cd active_model_conversion_spotlight
    bundle
```

* crank it

```
    bundle exec rake db:create # active record likes a database even tho we don't really use it here
    bundle exec rails s
```

* hit it 

    open http://localhost:3000

# credits

Thanks for the help, discussion and pairing from [Ken](https://github.com/viceversus) and [Jason](https://github.com/subakva)
