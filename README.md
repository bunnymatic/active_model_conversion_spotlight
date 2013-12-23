# widgets and `ActiveModel::Conversion`

You can easily build widget like classes which know how to find their own view by leveraging ActiveModel::Conversion

This came up on a recent project where the home page was going to be a handful of html blocks which showed some over all system status.  Without using widgets, we might have done something like this:

```
# controllers/pages_controller.rb#welcome

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
/ views/pages/index.slim
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

However, if these objects (`HotStuff`, `RecentActivity`, etc) knew how to render themselves, we could make this a bit simpler.  On the view side, we could do:

```
.main
  - @homepage_blocks.each do |block|
    section.block
      == render block
```

To get this to work, we need to leverage `ActiveModel::Conversion`.  This module adds the following methods: `#to_model`, `#to_key`, `#to_param`, and `#to_partial_path`.  These methods are used by `render` if you hand it an `Object` (as opposed to a `Symbol` or `String`.  Passing an `Object` to `render` will simply look up a partial path (using to_partial_paht) which looks like `<model_names>/_<model_name>.<format>` and pass the object to the partial in a variable called `<model_name>`.

Let's make this concrete.  Given the examples above, we could build a container which knows how to render itself.  Then we'll grab those widgets in the controller.  Let's start with `Stuff.hot`.

```
# in widgets/hot_stuff.rb
# the hot stuff wrapper
class HotStuff

  include ActiveModel::Conversion

  def items
    @items ||= Stuff.hot.limit(5)
  end
end
```

And for recent activity, we could do

```
# in widgets/recent_activity.rb
# the recent activity wrapper
class RecentActivity

  include ActiveModel::Conversion
  def items
    @items ||= Activity.recent.limit(5)
  end
end

```

Now we replace the controller logic
```
# in controllers/pages_controller.rb
  def welcome
    @homepage_blocks = [HotStuff.new, RecentActivity.new]
  end
```

The only thing left is to define partials for the widgets.  
```
/ in app/views/hot_stuffs/_hot_stuff.slim
h1 Hot Stuff has #{hot_stuff.items.count} things
```
```
/ in app/views/recent_activities/_recent_activity.slim
h1 There are #{recent_activity.items.count} recent bits of activity
```

That's it.  At this point, the home page should have 2 blocks, one showing the `_hot_stuff.slim` partial and the other showing the `_recent_activity.slim` partial.  I've constructed these partials to be pretty dumb, but you can imagine fleshing out the wrapper classes (not unlike building presenters) and adding to the partial to show what you need.

The sample app here includes the following widgets:

* SineWave
* SquareWave
* TriangleWave
* RandomFunction
* InstagramWidget
* GithubWidget

If you look through the code, you can see how things were built, but the first four include Javascript required to get the graphs drawn.  The partial for the model handles that bit.  And the other widgets are wrappers on a thin feed puller and draw the first few (or random) entries from their respective feeds.  The controller, in this case, simply chooses a random array of these widgets and renders them.  Each page refresh, you get a new set of widgets.

# develop

* clone it
```
    git clone https://
```
* bundle it
```
    bundle
```
* crank it
```
    bundle exec rails s
```
* hit it - point your browser to http://localhost:3000

