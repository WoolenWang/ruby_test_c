# -*- encoding : utf-8 -*-
# More info at https://github.com/guard/guard#readme
$LOAD_PATH.unshift File.join(File.dirname(__FILE__))
require 'woolen_common'
WoolenCommon::setup(File.dirname(__FILE__))

guard :rspec,:version => 2, :_run_all_after_pass => false do
  watch('spec/spec_helper.rb')  { 'spec' }

  watch(%r{^spec/(.+)_spec\.rb$}) { |m|
      WoolenCommon::SingleLogger.get_logger.debug "开始执行测试：：spec/#{m[1]}_spec.rb"
      "spec/#{m[1]}_spec.rb" }

  watch(%r{^src/(.+)\.rb$}) { |m|
      WoolenCommon::SingleLogger.get_logger.debug "开始执行测试：：spec/#{m[1]}_spec.rb"
      "spec/#{m[1]}_spec.rb"
  }
  watch(%r{^lib/(.+)\.rb$})     { |m|
      WoolenCommon::SingleLogger.get_logger.debug "开始执行测试：：spec/#{m[1]}_spec.rb"
      "spec/lib/#{m[1]}_spec.rb"
  }
  # Turnip features and steps
  watch(%r{^spec/acceptance/(.+)\.feature$})
  watch(%r{^spec/acceptance/steps/(.+)_steps\.rb$})   { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'spec/acceptance' }
end



## 这是设置sport跟着rspec启动么？
#guard 'spork', :rspec_env => {'RAILS_ENV' => 'test'} do
#    watch('config/application.rb')
#    watch('config/environment.rb')
#    watch(%r{^config/environments/.+\.rb$})
#    watch(%r{^config/initializers/.+\.rb$})
#    watch('Gemfile')
#    watch('Gemfile.lock')
#    watch('spec/spec_helper.rb')  { "spec" }
#    #watch('test/test_helper.rb')
#    watch('spec/support/')
#end
guard 'spork', :cucumber_env => { 'RAILS_ENV' => 'test' },  :rspec_env => { 'RAILS_ENV' => 'test' } do # 不需要cucumber，暂时
  watch(%r{^config/initial_proj/.+\.rb$})
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb') { :rspec }
  #watch('test/test_helper.rb') { :test_unit }
  #watch(%r{features/support/}) { :cucumber }
  watch('spec/support/')
  #watch(%r{^spec/.+_spec\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
end
