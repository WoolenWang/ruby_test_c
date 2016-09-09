# -*- encoding : utf-8 -*-
# This is the base Class for all the test obj
module EasyUnitTest
    class BaseClass
        include WoolenCommon::ToolLogger
        def platform_str
            if WoolenCommon::SystemHelper.is_x64?
                'x64'
            else
                'x32'
            end
        end
    end
end
