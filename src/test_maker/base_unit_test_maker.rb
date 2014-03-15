# -*- encoding : utf-8 -*-
require 'src/base_class'
module TestMaker
    class BaseUnitTestMaker < BaseClass
        def make_test_src(file_parser)
            raise '没有实现对应的make_test_src方法，你需要实现具体的方法'
        end

        def make_pre_compile_files(file_parser)
            raise '没有实现对应的 make_test_src方法，你需要实现具体的方法'
        end
    end
end