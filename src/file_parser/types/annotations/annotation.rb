# -*- encoding : utf-8 -*-
require 'src/base_class'
module FileParser
    class Annotation < BaseClass
        attr_accessor :raw_str

        def initialize(raw_str)
            @raw_str = raw_str
        end

    end
end