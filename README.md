# Larrow::Qingcloud

A simple wrapper for Qingcloud(IAAS)

## Installation

Add this line to your application's Gemfile:

    gem 'larrow-qingcloud'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install larrow-qingcloud

## Sample
before use Qingcloud API, you should establish connection first:

    Qingcloud.establish_connection <your_access_id>, <your_secret_key>

* list images

    images = Qingcloud::Image.describe

* create and destroy instance

    objs = Qingcloud::Instance.create count: 1
    Qingcloud::Instance.destroy instance_ids: objs.map(&:instance_id)

## Contributing

1. Fork it ( http://github.com/<my-github-username>/larrow-qingcloud/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
