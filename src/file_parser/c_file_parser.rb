# -*- encoding : utf-8 -*-
require 'src/file_parser/base_file_parser'
require 'src/file_parser/c_type'
module FileParser
    class CFileParser < BaseFileParser
        @functions = []
        @include_files = []

        def initialize(file_path)
            super(file_path)
        end

        def parse
            @functions = get_functions
            @include_files = get_include_files
        end

        def get_functions

        end

        def get_include_files

        end
    end
end