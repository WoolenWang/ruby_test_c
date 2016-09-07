# -*- encoding : utf-8 -*-
require 'rspec'
require 'src/file_parser/c_file_parser'
describe '解析C语言文件' do

    before :each do
        @c_file_parser = FileParser::C_FileParser.new(File.join(WoolenCommon::ConfigManager.project_root, 'spec/test_data/foo_test/foo.c'))
        @c_file_parser.parse
    end

    it 'should 获取include字段文件名' do
        @c_file_parser.include_files['foo.h'].file_name.should eq 'foo.h'
        @c_file_parser.include_files['stdio.h'].file_name.should eq 'stdio.h'
    end

    it 'should 获取函数相关信息（函数名，函数参数。。）' do
        @c_file_parser.functions['max'][0].return_type.should eq('int')
        @c_file_parser.functions['max'][0].param_array['a'].should eq('int')
        @c_file_parser.functions['max'][0].param_array['b'].should eq('int')
    end

    it 'should 解析到unit test的注解' do
        @c_file_parser.functions['max'][0].unit_test_annotation.raw_str.should include('unit_test')
    end

    it 'should 获取到before_action字符串包含do_nothing' do
        @c_file_parser.functions['max'][0].unit_test_annotation.raw_str.should include('unit_test')
    end

end
