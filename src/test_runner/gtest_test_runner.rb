# -*- encoding : utf-8 -*-
require 'src/test_runner/base_test_runner'
require 'src/file_parser/c_file_parser'
class GTest_TestRunner < BaseTestRunner
    GTEST_FILE_PREFIX = 'gtest_main'
    def make_file_parser(src_file)
        FileParser::C_FileParser.new(src_file)
    end




end

