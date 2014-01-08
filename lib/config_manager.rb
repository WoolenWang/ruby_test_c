# -*- encoding : utf-8 -*-
require 'yaml'
class ConfigManager
    class << self
        attr_accessor :root

=begin
	功能: 获取配置
	描述:
	      先设置好项目的根目录,如D:/ACAT3.1
		  返回为YAML对象的D:/ATCAT3.1/config/xx.yml
	参数: name 配置文件的名字
	返回值:
		  YAML对象
	       未设置root,抛出RuntimeErorr
		   配置不存在,抛出RuntimeErorr
	举例:
		  ConfigureManager.root = $root
		  puts ConfigureManager.get("test")['test']
=end
        def get(name)
            name += ".yml" unless name.match(/.yml$/)
            name = name.to_gbk
            raise "not set root path, please use ConfigureManager.root=() to set it" if root.nil?
            path = File.join(root, "Config", name) #File.join(root,"config",name).to_gbk
            path = File.expand_path(path)
            #~ path = Pathname.new(path).realpath
            raise "The special config path #{path.to_utf8} not exist" unless File.exist?(path)
            #  because empty file when get 'false' so we add {} return value.
            YAML.load_file(path) || {}
        end
    end
end
