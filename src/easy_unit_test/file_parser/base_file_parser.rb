# -*- encoding : utf-8 -*-
require 'src/easy_unit_test/base_class'
module EasyUnitTest
    module FileParser
        class BaseFileParser < BaseClass

            class << self
                attr_accessor :common_parser_config
            end

            attr_accessor :file_path

            def initialize(file_path)
                @file_path = file_path
                read_file_to_str
            end

            def read_file_to_str
                raise "给的路径 #{@file_path} 不是一个文件" unless File.file?(@file_path)
                @file_str ||= ''
                File.open(@file_path, 'rb') do |file|
                    @file_str = file.read
                end
            end

            def parse
                # to be finish by child
                raise 'not finish yet the child should redefine this function'
            end
        end
    end
end
