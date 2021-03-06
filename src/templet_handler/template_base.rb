# -*- encoding : utf-8 -*-
require 'erb'
module TemplateHandler
    class TemplateBase
        attr_accessor :include_files,:test_user_cases

        def initialize(file_path)
            @open_file_path = file_path
        end

        def get_binding
            binding
        end

        def get_template_result
            erb = ''
            File.open @open_file_path, 'rb' do |erb_file|
                erb = ERB.new(erb_file.read)
            end
            erb.result(get_binding)
        end

        def write_template_result_in_file(file)
            File.open file, 'wb' do |write_file|
                write_file.write get_template_result
                write_file.flush
            end
        end
    end
end
