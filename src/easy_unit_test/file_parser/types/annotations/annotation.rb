# -*- encoding : utf-8 -*-
require 'src/easy_unit_test/base_class'
module EasyUnitTest
    module FileParser
        class Annotation < BaseClass
            attr_accessor :raw_str

            def initialize(raw_str)
                @raw_str = raw_str
            end

        end
    end
end
