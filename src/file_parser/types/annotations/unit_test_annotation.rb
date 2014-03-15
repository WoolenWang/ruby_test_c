# -*- encoding : utf-8 -*-
require 'src/base_class'
require 'src/file_parser/types/base_type'
require 'src/file_parser/types/annotations/annotation'
module FileParser
    class UnitTestAnnotation < Annotation
        attr_accessor :user_cases, :before_actions, :after_actions, :belong_function

        def initialize(annotation_str,belong_function)
            super(annotation_str)
            @belong_function = belong_function
        end

        def get_before_actions
            @before_actions ||= make_before_actions
        end

        def get_after_actions
            @after_actions ||= make_after_actions
        end

        def get_user_cases
            @user_cases ||= make_user_cases
        end

        def make_before_actions
            raise '获取注解的相关信息由子类完成，这里做一个接口，请完成相关的方法'
        end

        def make_after_actions
            raise '获取注解的相关信息由子类完成，这里做一个接口，请完成相关的方法'
        end

        def make_user_cases
            raise '获取注解的相关信息由子类完成，这里做一个接口，请完成相关的方法'
        end

    end
end