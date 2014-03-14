# -*- encoding : utf-8 -*-
class TaskManager
    class << self
        def load_all_task
            Dir['tasks/*.task'].each do |task|
                load task
            end
        end
    end
end
