# -*- encoding : utf-8 -*-
require 'src/base_class'
require 'src/file_parser/base_type'
module FileParser
    class UnitTestAnnotation < BaseClass
        include Annotation

        def initialize(raw_str)
            @raw_str = raw_str
        end

    end
end