# -*- encoding : utf-8 -*-
require 'src/easy_unit_test/test_runner/base_test_runner'
require 'src/easy_unit_test/file_parser/c_file_parser'
require 'src/easy_unit_test/templet_handler/template_g_test'
require 'fileutils'
module EasyUnitTest
    module TestRunner
        class GTest_TestRunner < BaseTestRunner
            GTEST_TEMPLATE = File.realpath(File.join(WoolenCommon::ConfigManager.project_root, 'templet/c/gtest_main.c.erb'))

            def parse_file(src_file)
                parser = FileParser::C_FileParser.new(src_file)
                parser.parse
                parser
            end

            def template_write(file_parser)
                src_file = file_parser.file_path
                relate_dir = src_file.sub(File.realpath(@run_cfg['src_dir']), File.realpath(@run_cfg['out_dir']))
                FileUtils.mkdir_p File.dirname(relate_dir)
                debug "the src file #{src_file}"
                out_file = File.join(File.dirname(relate_dir), "#{File.basename(src_file).gsub('.','_')}_test.cpp")
                tmp = EasyUnitTest::TemplateHandler::TemplateGTest.new(GTEST_TEMPLATE)
                tmp.include_files = %w{foo.h foo.c}
                tmp.test_user_cases = []
                file_parser.functions_index.each do |function_name, function|
                    function.unit_test_annotation.get_user_cases.each do |user_case|
                        tmp.test_user_cases << user_case
                    end
                end
                tmp.test_file_name = 'foo.c'
                debug "need to write template to #{out_file}"
                tmp.write_template_result_in_file(out_file)
                out_file
            end

            def run_compile_cmd(file_parser, out_file)
                gtest_include = File.join(WoolenCommon::ConfigManager.project_root, 'framework/google_test/googletest/include')
                mock_include = File.join(WoolenCommon::ConfigManager.project_root, 'framework/google_test/googlemock/include')
                platform_link = File.join(WoolenCommon::ConfigManager.project_root, 'framework', platform_str)
                if WoolenCommon::SystemHelper.windows?
                    pthread_link = '-lwinpthread'
                else
                    pthread_link = '-lpthread'
                end
                the_cmd = "g++ #{out_file} -I#{gtest_include} -I#{mock_include} -I#{File.dirname(file_parser.file_path)} -L#{platform_link} -lgtest -lgmock #{pthread_link} -o #{out_file}_test"
                debug "the cmd\n#{the_cmd}"
                ret = `#{the_cmd}`
                debug ret
            end

            def run_test(out_file)
                run_str = `#{out_file}_test`
            end

            def analysis_test_result(test_result)
                info "run result #{test_result}"
            end
        end
    end
end

