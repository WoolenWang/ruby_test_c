require 'src/templet_handler/template_base'
require 'lib/system_helper'
module TemplateHandler
    class TemplateGTestMakeFile < TemplateBase
        include SystemHelper
        attr_accessor :file_parser,:test_case_src_name

        def initialize(open_file,file_parser=nil)
            super(open_file)
            @file_parser = file_parser
            # 计算出文件名称，不要后缀
            @test_case_src_name = TestMaker::GTestUnitTestMaker::GTEST_FILE_PREFIX + File.basename(@file_parser.file_path,'.c') unless file_parser.nil?
        end

        def platform_str
            if is_x64?
                'x64'
            else
                'x32'
            end
        end

        def test_project_share_head_dir
            './'
        end
        def test_project_share_lib_dir
            './'
        end
    end
end