require 'src/file_parser/base_type'
module FileParser
    class CType < BaseType
        STATIC_TYPE = %w{ uint8_t uint16_t uint32_t uint64_t char sort int long }
        ANNOTATION_REGEX = Regexp.new('(\s*/\*.*?(?!\*/).*?\*/)|(\s*\#if\s*0.*?(?!\#endif).*?\#endif)|(\s*//.*?$)', Regexp::MULTILINE)
        INCLUDE_REGEX = Regexp.new('\#include\s*[<"]+([\w+\.h]+)[">]*')
        FUNCTION_REGEX = Regexp.new('(?:(?<function_type>extern|static)(?:\s+)?(?<inline>inline)?(?:\s+))?(?:(?<return_type>(?:[a-zA-Z_]\w*)(?:\s*\*)?)\s+(?<function_name>[a-zA-Z_]\w*))\s*(?<param_str>\([^)]*?\))\s*(?<function_body>(?:\{([^{}]|\{([^{}]|\{[^{}]*\})*\})*\}))')
        # INCLUDE_REGEX = Regexp.new('(?<!(\s*/\*\s*)|(\s*//\s*))\#include\s*[<"]+([\w+\.h]+)[">]*(?!\s*\*/\s*)')
        class Function < BaseType
            RETURN_TYPE = STATIC_TYPE
            attr_accessor :return_type,:param_count,:params_types,:annotation
            def initialize(return_type,param_count,params_types)
                @return_type = return_type
                @param_count = param_count
                @params_types = params_types
            end
        end
        class UnitTestAnnotation < BaseType
            attr_accessor :raw_str, :user_cases, :befor_actions, :after_actions
            def initialize(raw_str)
                @raw_str = raw_str
            end

        end

    end
end