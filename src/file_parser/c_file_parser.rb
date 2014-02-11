# -*- encoding : utf-8 -*-
require 'src/file_parser/base_file_parser'
require 'src/file_parser/c_type'
require 'digest/md5'
module FileParser
    class CFileParser < BaseFileParser

        attr_accessor :functions,:include_files,:unit_test_annotations

        def initialize(file_path)
            @functions = {}
            @functions_index = {}
            @include_files = {}
            super(file_path)
        end

        def parse
            setup_functions
            setup_include_files
            setup_unit_test_annotation
        end

        def setup_functions
            function_type = CType::FUNCTION_REGEX.named_captures['function_type'][0] -1
            inline = CType::FUNCTION_REGEX.named_captures['inline'][0] -1
            return_type_index = CType::FUNCTION_REGEX.named_captures['return_type'][0] -1
            function_name_index = CType::FUNCTION_REGEX.named_captures['function_name'][0] -1
            param_str_index = CType::FUNCTION_REGEX.named_captures['param_str'][0] -1
            function_body_index = CType::FUNCTION_REGEX.named_captures['function_body'][0] -1
            @file_str.scan CType::FUNCTION_REGEX do |match_data|
                debug match_data
                function_name = match_data[function_name_index]
                return_type = match_data[return_type_index]
                param_str = match_data[param_str_index]
                function_body = match_data[function_body_index]
                function_str_index = @file_str.index function_body
                function = CType::Function.new(function_name,return_type,param_str,function_body,function_str_index)
                @functions[function_name] ||= []
                @functions[function_name] << function
                @functions_index[function_str_index] = function
            end
            debug @functions
            @functions
        end

        def setup_include_files
            index = CType::INCLUDE_REGEX.named_captures['include_files'][0] -1
            @file_str.scan CType::INCLUDE_REGEX do |match_data|
                include_file_name = match_data[index]
                @include_files[include_file_name] = CType::INCLUDE_FILE.new(include_file_name)
            end
            debug @include_files
            @include_files
        end

        def setup_unit_test_annotation
            annotation_str_index = CType::UNIT_TEST_ANNOTATION_REGEX.named_captures['annotation_str'][0] -1
            @file_str.scan CType::UNIT_TEST_ANNOTATION_REGEX do |match_data|
                annotation_str = match_data[annotation_str_index]
                if not annotation_str.nil? and annotation_str != '' and annotation_str.include? CType::UNIT_TEST_KEY
                    debug "the unit test annotation is \n" + annotation_str
                    function = find_unit_test_annotation_function(annotation_str)
                end
            end
        end

        def find_unit_test_annotation_function(annotation_str)
            functions_index_key_array = @functions_index.keys.sort
            annotation_str_key = @file_str.index(annotation_str)
            0.upto(functions_index_key_array.length-1) do |i|
                if functions_index_key_array[i] > annotation_str_key
                    @functions_index[functions_index_key_array[i]].unit_test_annotation = CType::UnitTestAnnotation.new(annotation_str)
                    return @functions_index[functions_index_key_array[i]]
                end
            end
            nil
        end
    end
end
