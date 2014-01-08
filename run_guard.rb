# -*- encoding : utf-8 -*-
#!/usr/bin/env ruby
#
# The application 'guard' is installed as part of a gem, and
# this file is here to facilitate running it.
#

$LOAD_PATH.unshift File.join(File.dirname(__FILE__))
require 'bundler'
begin
    # 设置Guad的目录
    Bundler.setup(Dir.pwd.to_sym, :guard)
rescue Bundler::BundlerError => e
    $stderr.puts e.message
    $stderr.puts "Run `bundle install` to install missing gems"
    exit e.status_code
end

version = ">= 0"

if ARGV.first =~ /^_(.*)_$/ and Gem::Version.correct? $1 then
    version = $1
    ARGV.shift
end

require "#{File.join(File.dirname(__FILE__),'config','initial_prj','initial')}"
require 'bundler/setup'
Bundler.require(:default)
gem 'guard', version
load Gem.bin_path('guard', 'guard', version)
