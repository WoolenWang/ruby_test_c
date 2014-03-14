# -*- encoding : utf-8 -*-
module FileParser
    class BaseType < BaseClass
    end
    class UserCase < BaseType
        INPUT_KEYWORD = 'input'
        EXPECTED_KEYWORD = 'should'
        INPUT_STR_REGEX = Regexp.new INPUT_KEYWORD + '\s+(.*)\s+' + EXPECTED_KEYWORD
        EXPECTED_STR_REGEX = Regexp.new EXPECTED_KEYWORD + '\s+(.*)\s+' + '$'
        attr_reader :input_str, :expected_return
        def initialize(user_case_str)
            make_input_str(user_case_str)
            expected_return_str(user_case_str)
        end

        def expected_return_str(user_case_str)
            @expected_return = match_regex_get_str(EXPECTED_STR_REGEX,user_case_str,'@expected_return')
        end

        def make_input_str(user_case_str)
            @input_str = match_regex_get_str(INPUT_STR_REGEX,user_case_str,'@input_str')
        end

        def match_regex_get_str(regex,src_str,info_msg)
            input_str_match_data = regex.match src_str
            if input_str_match_data.nil?
                error '获取不到' + info_msg
                nil
            else
                result = input_str_match_data[1]
                debug info_msg + '获取到是：：' + result
                result
            end
        end

    end
    module Annotation
        attr_accessor :raw_str, :user_cases, :before_actions, :after_actions
        def get_before_actions
            @before_actions ||= make_before_actions
        end

        def get_after_actions
            @after_actions ||= make_after_actions
        end

        def get_user_cases
            @user_cases ||= make_user_cases
        end

        def make_before_actions
            raise '获取注解的相关信息由子类完成，这里做一个接口，请完成相关的方法'
        end

        def make_after_actions
            raise '获取注解的相关信息由子类完成，这里做一个接口，请完成相关的方法'
        end

        def make_user_cases
            raise '获取注解的相关信息由子类完成，这里做一个接口，请完成相关的方法'
        end
    end
end
