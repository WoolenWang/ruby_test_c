# -*- encoding : utf-8 -*-
require 'rubygems'
# 添加项目路径做LoadPath
#`bundle.bat check`
#if $? != 0
#    `bundle.bat install --system`
#    result = `bundle.bat check`
#    if $? != 0
#        puts "#{result}"
#        exit 1
#    end
#end
#$stdouttype = 'GBK'
require "#{File.join(File.dirname(__FILE__),'config','initial_prj','initial')}"
require 'bundler/setup'
Bundler.require(:default)
TaskManager.load_all_task
