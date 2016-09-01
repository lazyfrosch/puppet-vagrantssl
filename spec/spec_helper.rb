require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
require 'facterdb'
include RspecPuppetFacts

at_exit { RSpec::Puppet::Coverage.report! }
