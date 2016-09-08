# -*- encoding : utf-8 -*-
require 'rspec'
require 'src/easy_unit_test/file_parser/c_file_parser'
require 'src/easy_unit_test/file_parser/types/c_type'
describe 'C语言的相关类型获取' do

    before :each do
        @c_file_parser = EasyUnitTest::FileParser::C_FileParser.new(File.join(WoolenCommon::ConfigManager.project_root, 'spec/test_data/foo_test/foo.c'))
        @c_file_parser.parse
        @c_annotation = @c_file_parser.functions['max'][0].unit_test_annotation
    end

    it 'should 获取到before_action字符串包含do_nothing' do
        @c_annotation.get_before_actions_str(@c_annotation.raw_str).should include('do_nothing')
    end

    it 'should 获取到的before_action包含do_nothing' do
        @c_annotation.get_before_actions.should include('do_nothing')
    end

    it 'should 获取user_case 0 个包含 input 1,2' do
        @c_annotation.get_user_cases[0].input_str.should include('1,2')
    end

    it 'should 获取user_case 0 个包含 return 3' do
        @c_annotation.get_user_cases[0].expected_str.should include('2')
    end

end
