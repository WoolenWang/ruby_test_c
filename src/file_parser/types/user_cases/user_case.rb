# -*- encoding : utf-8 -*-

module FileParser
    class UserCase < BaseType
        INPUT_KEYWORD = 'input'
        EXPECTED_KEYWORD = 'should'
        INPUT_STR_REGEX = Regexp.new INPUT_KEYWORD + '\s+(.*)\s+' + EXPECTED_KEYWORD
        EXPECTED_STR_REGEX = Regexp.new EXPECTED_KEYWORD + '\s+(.*)\s+' + '$'
        # input_str 是对应的一行用例中的输入部分（关键词input)
        # name 是得到对应的用例的名称，对应第几个用例
        # function 是对应的解析到的函数结构

        attr_reader :input_str, :expected_str, :name, :run_src, :function

        def initialize(user_case_str, name,function)
            @name = name
            @function = function
            make_input_str(user_case_str)
            expected_return_str(user_case_str)
        end

        def expected_return_str(user_case_str)
            @expected_str = match_regex_get_str(EXPECTED_STR_REGEX, user_case_str, '@expected_str')
        end

        def make_input_str(user_case_str)
            @input_str = match_regex_get_str(INPUT_STR_REGEX, user_case_str, '@input_str')
        end

        def match_regex_get_str(regex, src_str, info_msg)
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

        def running_code
            @run_src ||= get_running_code
        end

        def get_running_code
            raise '生成具体的执行代码，由具体的单元测试框架模块实现'
        end
    end
end