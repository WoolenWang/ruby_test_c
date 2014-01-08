# -*- encoding : utf-8 -*-
require 'lib/logger'
class Common_Class
    class << self
        include ToolLogger
        def wait_until_stopped
            info 'Press ENTER or c-C to stop it'
            $stdout.flush
            begin
                STDIN.gets
            rescue Interrupt
                info "Interrupt"
            end
        end
    end
end
