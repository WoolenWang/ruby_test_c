# -*- encoding : utf-8 -*-
require 'src/file_parser/types/annotations/unit_test_annotation'
require 'src/file_parser/types/user_cases/g_test_user_case'

module FileParser
    class GTestAnnotation < UnitTestAnnotation
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
            user_case_array.each_index do |user_case_str_idx|
                result_array << GTestUserCase.new(user_case_array[user_case_str_idx],"#{@belong_function.function_name}:case_no:#{user_case_str_idx}",@belong_function)
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
            debug "#{BEFORE_ACTIONS_REGEX}"
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