# -*- encoding : utf-8 -*-
require 'src/easy_unit_test/templet_handler/template_base'
module EasyUnitTest
    module TemplateHandler
        class TemplateGTest < TemplateBase
            attr_accessor :test_file_parser, :test_file_name
        end
    end
end
