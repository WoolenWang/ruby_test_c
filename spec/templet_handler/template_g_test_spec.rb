# -*- encoding : utf-8 -*-
require 'spec/spec_helper'
require 'src/templet_handler/template_g_test'
require 'src/file_parser/c_file_parser'
describe 'TemplateGTest' do
    describe 'write_template_result_in_file' do
        before :each do
            @c_file_parser = FileParser::C_FileParser.new(File.join(ConfigManager.project_root, 'spec/test_data/foo_test/foo.c'))
            @c_file_parser.parse
        end
        it 'should 写出一个c源程序到tmp里面' do
            tmp = TemplateHandler::TemplateGTest.new('templet/c/gtest_main.c.erb')
            tmp.include_files =  %w{foo.h foo.c}
            tmp.test_user_cases = []
            @c_file_parser.functions_index.each do |function_name,function|
                function.unit_test_annotation.get_user_cases.each do |user_case|
                    tmp.test_user_cases << user_case
                end
            end
            tmp.test_file_name = 'foo.c'
            tmp.write_template_result_in_file('tmp/gtest_main.c')
            (File.exists? 'tmp/gtest_main.c').should == true
        end
    end
end
