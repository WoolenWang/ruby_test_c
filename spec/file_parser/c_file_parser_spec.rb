require 'rspec'
require 'src/file_parser/c_file_parser'
describe '解析C语言文件' do

    before :each do
        @c_file_parser = FileParser::CFileParser.new(File.join(ConfigManager.project_root, 'spec/test_data/foo_test/foo.c'))
    end

    it 'should 获取include字段文件名' do
        @c_file_parser.get_include_files.should include('foo.h')
    end

end