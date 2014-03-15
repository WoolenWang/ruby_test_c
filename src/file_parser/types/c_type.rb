# -*- encoding : utf-8 -*-
require 'src/file_parser/types/user_cases/user_case'
require 'src/file_parser/types/base_type'
module FileParser
    class CType < BaseType
        STATIC_TYPE = %w{ uint8_t uint16_t uint32_t uint64_t char sort int long }
        ANNOTATION_REGEX = Regexp.new('(\s*/\*.*?(?!\*/).*?\*/)|(\s*\#if\s*0.*?(?!\#endif).*?\#endif)|(\s*//.*?$)', Regexp::MULTILINE)
        UNIT_TEST_ANNOTATION_REGEX = Regexp.new('\s*/\*(?<annotation_str>[\s\S]*?(?!\*/)[\s\S]*?)\*/')
        UNIT_TEST_KEY = 'unit_test'
        INCLUDE_REGEX = Regexp.new('\#include\s*[<"]+(?<include_files>[\w+\.h]+)[">]*')
        FUNCTION_REGEX = Regexp.new('(?:(?<function_type>extern|static)(?:\s+)?(?<inline>inline)?(?:\s+))?(?:(?<return_type>(?:[a-zA-Z_]\w*)(?:\s*\*)?)\s+(?<function_name>[a-zA-Z_]\w*))\s*(?<param_str>\([^)]*?\))\s*(?<function_body>(?:\{([^{}]|\{([^{}]|\{[^{}]*\})*\})*\}))')
        ONE_PARAM_REGEX = Regexp.new '\s*(\w+)\s*(\w+)\s*'
        # INCLUDE_REGEX = Regexp.new('(?<!(\s*/\*\s*)|(\s*//\s*))\#include\s*[<"]+([\w+\.h]+)[">]*(?!\s*\*/\s*)')
    end
    class C_IncludeFile < CType
        attr_accessor :file_name, :include_files, :define_functions

        def initialize(file_name)
            @file_name = file_name
        end
    end
    class C_Function < CType
        include Function
        RETURN_TYPE = STATIC_TYPE
        attr_accessor :return_type, :function_name, :param_array, :annotation, :function_body, :function_str_index, :unit_test_annotation

        def initialize(function_name, return_type, param_str, function_body, function_str_index)
            @return_type = return_type
            @function_name = function_name
            @param_array = parse_param_str(param_str)
            @function_body = function_body
            @function_str_index = function_str_index
        end

        def parse_param_str(param_str)
            tmp_param_array = {}
            no_bracket_param_str = param_str[1...-1]
            debug '脱去括号后的参数字符串是：：' + no_bracket_param_str
            param_str_array = no_bracket_param_str.split ','
            debug '脱掉逗号的参数数组是：：' + param_str_array.to_s
            param_str_array.each do |one_param_str|
                match_data = ONE_PARAM_REGEX.match one_param_str
                tmp_param_array[match_data[2]] = match_data[1]
            end
            debug '生成最后的hash：：' + tmp_param_array.to_s
            tmp_param_array
        end
    end


end
