# -*- encoding : utf-8 -*-
require 'src/easy_unit_test/test_runner/base_test_runner'
require 'src/easy_unit_test/file_parser/c_file_parser'

module EasyUnitTest
    class GTest_TestRunner < BaseTestRunner
        def make_file_parser(src_file)
            FileParser::C_FileParser.new(src_file)
        end
    end
end

