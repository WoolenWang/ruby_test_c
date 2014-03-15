# -*- encoding : utf-8 -*-
require 'src/test_maker/base_unit_test_maker'
module TestMaker
    class GTestUnitTestMaker < BaseUnitTestMaker
        GTEST_TEMPLATE_FILE = 'templet/c/gtest_main.c.erb'
        GTEST_FILE_PREFIX = 'gtest_main_'

        def make_test_src(file_parser)
            gtest_file = File.join(file_parser.file_path.dirname, GTEST_FILE_PREFIX + File.basename(file_parser.file_path,'c'))
            gtest_file_tmp = gtest_file + '_tmp'
            File.delete gtest_file
            test_template = TemplateGTest.new(GTEST_TEMPLATE_FILE)
            test_template.test_file_parser = file_parser
            test_template.write_template_result_in_file(gtest_file_tmp)
            FileUtils.mv(gtest_file_tmp, gtest_file, :force => true)
        end

        def make_pre_compile_files(file_parser)
            raise '没有实现对应的 make_pre_compile_files 方法，你需要实现具体的方法'
        end
    end
end