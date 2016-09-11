# -*- encoding : utf-8 -*-
require 'rspec'
require 'spec/spec_helper'
require 'src/easy_unit_test/test_runner/gtest_test_runner'

describe '运行测试' do
  before :each do
    @test_runner = EasyUnitTest::TestRunner::GTest_TestRunner.new
  end

  it 'should 运行一个文件的单侧' do
    @test_runner.run(File.join(WoolenCommon::ConfigManager.project_root, 'spec/test_data/foo_test/foo.c'))
  end
end
