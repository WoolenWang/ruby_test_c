# -*- encoding : utf-8 -*-
require 'singleton'
require 'src/easy_unit_test/base_class'
require 'src/easy_unit_test/file_parser/base_type'
module EasyUnitTest
    class BaseAnnotationAnalyzer < BaseClass
        include Singleton
        # 支持分析一个字符串或者是一个annotation类的东东
        def analysis(annotation)
            if annotation.kind_of? Annotation
                str = annotation.raw_str
            else
                str = annotation
            end
        end
    end
end
