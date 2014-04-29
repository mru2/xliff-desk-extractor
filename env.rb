# Require paths
$LOAD_PATH.unshift File.dirname(__FILE__)

# Environment
require 'rubygems'
require 'bundler'

Bundler.setup
Bundler.require(:default)

require 'dotenv'
Dotenv.load

# Libs
require 'lib/desk_articles'
require 'lib/xliff'
