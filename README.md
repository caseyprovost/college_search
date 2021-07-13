# College Search

### Getting started
* cd into the project and bundle
* Run `bin/rails s` to start the server
* You can now search colleges to your heart's content :)

### Run Tests

```
bin/rake test
```

### If this was a real app
* Likely there would be a weekly/monthly CRON that downloaded, updated, deleted colleges in a local database.
* RSpec would be the tool of choice
* The messier controller code would be extracted into an interactor or API wrapper
* Docker would be the default
* There would be spam/bot detection since it is a public since the page is not behind login
* Tailwind + ERB + Webpacker would be the default tools
* The Javscript wouldn't be in the page, but in a Stimulus controller or something of that variety

### Trade-offs
* This is structured as a decently-tested POC simply due to time constraints
* Chose to implement a quick-and-dirty caching strategy. This would likely be better served in Redis, or even in the DB.
