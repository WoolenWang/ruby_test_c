$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'..','..')
require 'lib/config_manager'
ConfigManager.root = File.join(File.dirname(__FILE__),'..','..')
require 'lib/task_manager'
require 'lib/logger'