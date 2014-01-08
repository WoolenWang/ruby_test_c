require 'spec/spec_helper'
require 'src/templet_handler/template_base'
describe 'TemplateBase' do
    describe 'write_template_result_in_file' do
        it 'should write template file in the tmp dir' do
            tmp = TemplateBase.new('templet/c/gtest_main.c.erb')
            tmp.write_template_result_in_file('tmp/gtest_main.c')
            p File.file? 'tmp/gtest_main.c'
        end
    end
end