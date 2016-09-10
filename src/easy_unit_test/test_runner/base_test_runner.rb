# -*- encoding : utf-8 -*-
require 'src/easy_unit_test/base_class'
require 'fileutils'

# 测试运行的整体大管家
module EasyUnitTest
    module TestRunner
        class BaseTestRunner < BaseClass
            DEFAULT_RUN_CFG = {
                'src_dir' => File.absolute_path(File.join(WoolenCommon::ConfigManager.project_root, 'spec/test_data')),
                'framework' => 'gtest',
                'out_dir' => File.absolute_path(File.join(WoolenCommon::ConfigManager.project_root, 'tmp'))
            }
            attr_accessor :run_cfg

            def initialize(run_cfg = {})
                @run_cfg = DEFAULT_RUN_CFG.merge(run_cfg)
                FileUtils.mkdir_p @run_cfg['out_dir'] unless File.exist? @run_cfg['out_dir']
            end

            # 对于某个文件的变化，执行对于该文件得到的单元测试信息，这里是针对文件来进行测试的
            # 这里要可从入的，为了支持多线程情况
            def run(src_file)
                debug "need to run test with file #{src_file}"
                file_parser = parse_file(src_file)
                out_file = template_write(file_parser)
                run_compile_cmd(file_parser,out_file)
                test_result=run_test(out_file)
                analysis_test_result(test_result)
            end

            def make_test_maker(file_parser)
                raise '没有实现对应的 make_test_maker 方法，你需要实现具体的方法'
            end

            def parse_file(src_file)
                error '你不应该跑到这里新建一个通用的文件解析器'
                FileParser::BaseFileParser.new(src_file)
            end

            def template_write(file_parser)
                raise '没有实现对应的 template_write 方法，你需要实现具体的方法'
            end


            def run_compile_cmd(file_parser,out_file)
                raise '没有实现对应的 run_compile_cmd 方法，你需要实现具体的方法'
            end

            def run_test(out_file)
                raise '没有实现对应的 run_test 方法，你需要实现具体的方法'
            end

            def analysis_test_result(test_result)
                raise '没有实现对应的 analysis_test_result 方法，你需要实现具体的方法'
            end
        end
    end
end

