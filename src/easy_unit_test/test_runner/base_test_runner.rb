# -*- encoding : utf-8 -*-
require 'src/easy_unit_test/base_class'

# 测试运行的整体大管家
module EasyUnitTest
    class BaseTestRunner < BaseClass
        # 对于某个文件的变化，执行对于该文件得到的单元测试信息，这里是针对文件来进行测试的
        # 这里要可从入的，为了支持多线程情况
        def run(src_file, is_make_file)
            file_parser = make_file_parser(src_file)
            if is_make_file
                test_maker = make_test_maker(file_parser)
                test_maker.make_test_src(file_parser)
                test_maker.make_pre_compile_files(file_parser)
            end
            run_compile_cmd(file_parser)
            test_result=run_test(file_parser)
            analysis_test_result(test_result)
        end

        def make_test_maker(file_parser)
            raise '没有实现对应的 make_test_maker 方法，你需要实现具体的方法'
        end

        def make_file_parser(src_file)
            error '你不应该跑到这里新建一个通用的文件解析器'
            FileParser::BaseFileParser.new(src_file)
        end


        def run_compile_cmd(file_parser)
            raise '没有实现对应的 run_compile_cmd 方法，你需要实现具体的方法'
        end

        def run_test(file_parser)
            raise '没有实现对应的 run_test 方法，你需要实现具体的方法'
        end

        def analysis_test_result(test_result)
            raise '没有实现对应的 analysis_test_result 方法，你需要实现具体的方法'
        end
    end
end

