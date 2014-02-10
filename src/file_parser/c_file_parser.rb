# -*- encoding : utf-8 -*-
require 'src/file_parser/base_file_parser'
require 'src/file_parser/c_type'
require 'digest/md5'
module FileParser
    class CFileParser < BaseFileParser

        attr_accessor :functions,:include_files

        def initialize(file_path)
            @functions = {}
            @include_files = {}
            super(file_path)
        end

        def parse
            setup_functions
            setup_include_files
        end

        def setup_functions
            @file_str.scan CType::FUNCTION_REGEX do |match_data|
                function_type = CType::FUNCTION_REGEX.named_captures['function_type'][0] -1
                inline = CType::FUNCTION_REGEX.named_captures['inline'][0] -1
                return_type_index = CType::FUNCTION_REGEX.named_captures['return_type'][0] -1
                function_name_index = CType::FUNCTION_REGEX.named_captures['function_name'][0] -1
                param_str_index = CType::FUNCTION_REGEX.named_captures['param_str'][0] -1
                function_body_index = CType::FUNCTION_REGEX.named_captures['function_body'][0] -1
                function_name = match_data[function_name_index]
                return_type = match_data[return_type_index]
                param_str = match_data[param_str_index]
                function_body = match_data[function_body_index]
                function = CType::Function.new(function_name,return_type,param_str,function_body)
                @functions[function_name] ||= []
                @functions[function_name] << function
            end
            debug @functions
            @functions
        end

        def setup_include_files
            @file_str.scan CType::INCLUDE_REGEX do |match_data|
                index = CType::INCLUDE_REGEX.named_captures['include_files'][0] -1
                include_file_name = match_data[index]
                @include_files[include_file_name] = CType::INCLUDE_FILE.new(include_file_name)
            end
            debug @include_files
            @include_files
        end
    end
end