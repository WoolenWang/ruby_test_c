# -*- encoding : utf-8 -*-
# This is the base Class for all the test obj
module EasyUnitTest
    class BaseClass
        include WoolenCommon::ToolLogger
        def platform_str
            if WoolenCommon::SystemHelper.windows?
                'win32'
            else
                if WoolenCommon::SystemHelper.is_x64?
                    'linux_x64'
                else
                    'linux_x32'
                end
            end
        end
    end
end
