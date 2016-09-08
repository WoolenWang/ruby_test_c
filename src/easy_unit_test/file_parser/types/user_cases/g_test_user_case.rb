# -*- encoding : utf-8 -*-

require 'src/easy_unit_test/file_parser/types/user_cases/user_case'
module EasyUnitTest
    module FileParser
        class GTestUserCase < UserCase
            TYPE_RETURN = 'return'
            TYPE_BE_TRUE = 'be_true'
            TYPE_BE_FALSE = 'be_false'
            EXPECT_TYPE_RETURN_REGEX = Regexp.new '^return\s*(.*)$'
            EXPECT_TYPE_BE_TRUE_REGEX = Regexp.new '^be_true\s*(.*)$'
            EXPECT_TYPE_BE_FALSE_REGEX = Regexp.new '^be_false\s*(.*)$'
            attr_accessor :expect_type, :param_str
            # 这个函数比较重要，是用于生成每个单元测试用力中的执行代码的，执行前要设置好相关的实例变量
            def get_running_code
                running_code = ''
                if @function.return_type == '' || @function.return_type.include?('void')
                    running_code << "   #{@function.function_name}(#{@input_str}); \n"
                else
                    running_code << "   #{@function.return_type} run_result = #{@function.function_name}( #{@input_str} ); \n"
                end
                case make_expect_type
                    when TYPE_RETURN
                        running_code << "   EXPECT_EQ(run_result,#{param_str});"
                    when TYPE_BE_TRUE
                        running_code << "   EXPECT_TRUE(#{param_str});"
                    when TYPE_BE_FALSE
                        running_code << "   EXPECT_FALSE(#{param_str});"
                    else
                        error "不知道是什么类型的期望：：#{@expect_type}"
                end
                running_code
            end

            def make_expect_type
                @expect_type ||= get_expect_type(@expected_str)
            end

            def get_expect_type(expected_str)
                case expected_str
                    when EXPECT_TYPE_RETURN_REGEX
                        match_data = EXPECT_TYPE_RETURN_REGEX.match expected_str
                        @param_str = match_data[1]
                        return TYPE_RETURN
                    when EXPECT_TYPE_BE_TRUE_REGEX
                        match_data = EXPECT_TYPE_BE_TRUE_REGEX.match expected_str
                        @param_str = match_data[1]
                        return TYPE_BE_TRUE
                    when EXPECT_TYPE_BE_FALSE_REGEX
                        match_data = EXPECT_TYPE_BE_FALSE_REGEX.match expected_str
                        @param_str = match_data[1]
                        return TYPE_BE_FALSE
                    else
                        return TYPE_RETURN
                end
            end
        end
    end
end
