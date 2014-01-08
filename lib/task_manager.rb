# -*- encoding : utf-8 -*-
class TaskManager
    class << self
        def load_all_task
            Dir['Tasks/*.task'].each do |task|
                load task
            end
        end
    end
end
