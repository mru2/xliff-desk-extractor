# Require paths
$LOAD_PATH.unshift File.dirname(__FILE__)

# Environment
require 'rubygems'
require 'bundler'

Bundler.setup
Bundler.require(:default)

require 'dotenv'
Dotenv.load

# Root dir
ROOT_DIR = File.expand_path(File.dirname __FILE__)

# Libs
require 'lib/desk'
require 'lib/xliff'
require 'lib/importer'
require 'lib/syncer'
