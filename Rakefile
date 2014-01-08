# -*- encoding : utf-8 -*-
require 'rubygems'
# 添加项目路径做LoadPath
$LOAD_PATH.unshift File.join(File.dirname(__FILE__))
`bundle.bat check`
if $? != 0
    `bundle.bat install --system`
    result = `bundle.bat check`
    if $? != 0
        puts "#{result}"
        exit 1
    end
end
#$stdouttype = 'GBK'
require 'bundler/setup'
Bundler.require(:default)
require 'lib/config_manager'
ConfigManager.root = File.dirname(__FILE__)
require 'lib/task_manager'
require 'lib/logger'
TaskManager.load_all_task
