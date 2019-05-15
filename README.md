# BPL::Derivatives

Modified version of [samvera/hydra-derivatives](https://github.com/samvera/hydra-derivatives) to be backwards compatible with Fedora Commons 3.8.1.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bpl-derivatives'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bpl-derivatives

## Usage

Currently there is no implementation of the `ActiveTranscoder` features. Also the Audio and Video derivatives have not been thoroughly tested either.  

The main purpose of this was to make newer versions of hydra-derivatives backwards compatible with Fedora 3.8.1 datastreams. Rather than fork this from Samvera I determined that the BPL's use case was out of their current scope and instead implemented this version. Also be aware this has not been tested with `ActiveFedora > 9`


Given an `ActiveFedora` Model Like So
```ruby
class MyObject < ActiveFedora::Base
  has_file_datastream 'masterFile' ..
end
```

You can now add the following
```ruby
  class MyObject < ActiveFedora::Base
    include BPL::Derivatives
    ...
    ...
    def generate_derivatives
      case self.masterFile.mimeType
      when 'image/tif'
        derivatize runner: :jpeg2k_image, source_datastream: "masterFile", outputs: [ {recipe: :default, dsid:  'myJp2kDatastream'  } ]
        derivatize runner: :image, source_datastream: "masterFile", outputs: [
           { label: :thumb, size: "x800>", dsid: 'my800pxThumbDS', format: 'jpg' },
           { label: :thumb, size: "300x300>", dsid: 'my300pxThumbDS', format: 'jpg' }
         ]
      when 'application/pdf'
        derivatize runner: :image, source_datastream: "masterFile", outputs: [{label: :thumb, size: "300x300>", dsid: 'my300pxThumbDD', format: 'jpg', quality: 100, density: 200, layer: 0}] #Recommend passing in quality denisty and layer 0 for pdfs   

```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/boston-library/bpl-derivatives.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
