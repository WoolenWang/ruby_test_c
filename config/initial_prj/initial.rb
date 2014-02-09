$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'..','..')
require 'lib/config_manager'
ConfigManager.project_root = File.expand_path(File.join(File.dirname(__FILE__),'..','..'))
require 'lib/task_manager'
require 'lib/logger'