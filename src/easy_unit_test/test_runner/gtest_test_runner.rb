# -*- encoding : utf-8 -*-
require 'src/easy_unit_test/test_runner/base_test_runner'
require 'src/easy_unit_test/file_parser/c_file_parser'
require 'src/easy_unit_test/templet_handler/template_g_test'

module EasyUnitTest
    module TestRunner
        class GTest_TestRunner < BaseTestRunner
            def make_file_parser(src_file)
                parser = FileParser::C_FileParser.new(src_file)
                parser.parse
                parser
            end

            def run_compile_cmd(file_parser)
                g_test_template = File.realpath(File.join(WoolenCommon::ConfigManager.project_root,'templet/c/gtest_main.c.erb'))
                out_file = File.realpath(File.join(WoolenCommon::ConfigManager.project_root,'tmp/gtest_main.c'))
                tmp = EasyUnitTest::TemplateHandler::TemplateGTest.new(g_test_template)
                tmp.include_files =  %w{foo.h foo.c}
                tmp.test_user_cases = []
                file_parser.functions_index.each do |function_name,function|
                    function.unit_test_annotation.get_user_cases.each do |user_case|
                        tmp.test_user_cases << user_case
                    end
                end
                tmp.test_file_name = 'foo.c'
                tmp.write_template_result_in_file(out_file)
                the_cmd = "g++ #{out_file} -I#{File.join(WoolenCommon::ConfigManager.project_root,'framework/include')} -I#{File.dirname(file_parser.file_path)} -L#{File.join(WoolenCommon::ConfigManager.project_root,'framework',platform_str)} -lgtest_main -lgtest -lgmock_main -lgmock -lpthread -o #{file_parser.file_path}_test"
                debug "the cmd #{the_cmd}"
                ret = `#{the_cmd}`
                debug ret
            end

            def run_test(file_parser)
                run_str = `#{file_parser.file_path}_test`
            end

            def analysis_test_result(test_result)
                info "run result #{test_result}"
            end
        end
    end
end

