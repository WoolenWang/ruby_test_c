# -*- encoding : utf-8 -*-
require 'spec/spec_helper'
require 'src/templet_handler/template_g_test_make_file'
require 'src/file_parser/base_file_parser'
require 'src/file_parser/c_file_parser'
require 'src/test_maker/gtest_unit_test_maker'
describe 'TemplateGTestMakeFile' do
    describe 'write_template_result_in_file' do
        before :each do
            @c_file_parser = FileParser::C_FileParser.new(File.join(WoolenCommon::ConfigManager.project_root, 'spec/test_data/foo_test/foo.c'))
            @c_file_parser.parse
        end
        it 'should 写出一个Makefile出来' do
            tmp = TemplateHandler::TemplateGTestMakeFile.new('templet/make_file/gtest.makefile.erb',@c_file_parser)
            tmp.file_parser =  @c_file_parser
            tmp.write_template_result_in_file('tmp/Makefile')
        end
    end
end
