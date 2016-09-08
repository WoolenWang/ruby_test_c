require 'rspec'
require 'spec/spec_helper'
require 'src/easy_unit_test/test_runner/gtest_test_runner'

describe '运行测试' do

  it 'should 运行一个文件的单侧' do

    true.should == false
  end
end