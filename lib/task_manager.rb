# -*- encoding : utf-8 -*-
module TestTool
    class TaskManager
        class << self
            def load_tool_task
                Dir['Tasks/*.task'].each do |task|
                    load task
                end
            end
        end
    end
end
