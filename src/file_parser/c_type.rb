# -*- encoding : utf-8 -*-
require 'src/file_parser/base_type'
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

    class C_UnitTestAnnotation < UnitTestAnnotation
        BEFORE_ACTION_KEY = 'before_action'
        USER_CASE_KEY = 'user_case'
        AFTER_ACTION_KEY = 'after_action'
        BEFORE_ACTIONS_REGEX = Regexp.new '[\s\S]*' + BEFORE_ACTION_KEY + '\:*(?<before_action_str>[\s\S]*)' + USER_CASE_KEY
        USER_CASES_REGEX = Regexp.new '[\s\S]*' + USER_CASE_KEY + '\:*(?<user_cases_str>[\s\S]*)' + AFTER_ACTION_KEY
        NO_NOTE_REGEX = Regexp.new '^\s*\*\s*|\s*$'

        # 完成unit test的实现函数，被父类调用
        def make_user_cases
            if @raw_str == nil or @raw_str == ''
                error '没有读取到注解!'
                return nil
            end
            result_array = []
            user_case_array = get_user_cases_array(@raw_str)
            user_case_array.each do |user_case_str|
                result_array << UserCase.new(user_case_str)
            end
            result_array
        end

        def get_user_cases_array(str)
            user_cases_str_match_data = USER_CASES_REGEX.match str
            if user_cases_str_match_data.nil?
                error '匹配不上数据，没有找到before_action'
                return ''
            end
            user_case_str = user_cases_str_match_data['user_cases_str']
            debug '匹配到的user_case_str：：' + "\n" + user_case_str.gsub(NO_NOTE_REGEX, '')
            user_case_str_to_array(user_case_str.gsub(NO_NOTE_REGEX, ''))
        end

        def user_case_str_to_array(str)
            user_case_array = []
            str.each_line do |line|
                user_case_array << line
            end
            debug '得到的user_case_array：：' + "\n" + user_case_array.join('')
            user_case_array
        end

        # 完成unit test的实现函数，被父类调用
        def make_before_actions
            if @raw_str == nil or @raw_str == ''
                error '没有读取到注解!'
                return nil
            end
            get_before_actions_str(@raw_str)
        end

        def deal_with_before_action_str(before_action_str)

        end

        def get_before_actions_str(str)
            debug '获得的是annotation 字符串是：：' + str
            debug BEFORE_ACTIONS_REGEX
            after_action_str_match_data = BEFORE_ACTIONS_REGEX.match str
            if after_action_str_match_data.nil?
                error '匹配不上数据，没有找到before_action'
                return ''
            end
            after_action_str = after_action_str_match_data['before_action_str']
            debug '匹配到的before_action：：' + after_action_str.gsub(NO_NOTE_REGEX, '')
            after_action_str.gsub(NO_NOTE_REGEX, '')
        end
    end
end
