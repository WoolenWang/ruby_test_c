# -*- encoding : utf-8 -*-
require 'logger'
require 'yaml'
require 'pathname'
require 'lib/util/system_helper'
require 'src/test_tool/config_manager'
require 'src/test_tool/test_tool'
module TestTool
    class MyLogger # :nodoc: all
        include SystemHelper
        LEVELS = ["DEBUG", "INFO", "WARN", "ERROR", "FATAL"]
        COLORS = { 'DEBUG' => 'white', 'INFO' => 'green', 'WARN' => 'yellow', 'ERROR' => 'purple', 'FATAL' => 'red' }
        WIN_PRINTER = Pathname.new(File.join(__FILE__, '..', 'puts_color.exe')).realpath.to_s
        attr_reader :file, :stdout, :name
        attr_accessor :level

        LOGGERS = []

        def my_puts(message, color = nil)
            if windows?
                the_color = color || 'default'
                #puts WIN_PRINTER
                #puts "#{WIN_PRINTER} #{the_color} default \"#{message}\""
                #system("#{WIN_PRINTER} #{the_color} default \"#{message}\n\"")
                begin
                    system("#{WIN_PRINTER} #{the_color} default \"#{message.gsub('"', '\"')}\"")
                rescue Exception => e
                    puts "#{message}"
                end
            else
                case color
                    when 'red'
                        color = '31;1'
                    when 'green'
                        color = '32;1'
                    when 'yellow'
                        color = '33;1'
                    when 'blue'
                        color = '34;1'
                    when 'purple'
                        color = '35;1'
                    when 'sky'
                        color = '36;1'
                    else
                        color = '36;1'
                end
                print "\e[#{color}m#{message}\e[0m\n"
            end
        end


        def initialize(attrs = {})
            #puts "=> init logger with: #{attrs.inspect}"
            @stdout = (attrs[:stdout] == 1)
            @name = attrs[:name]
            @filename = attrs[:file]
            @file = File.open(@filename, "a+") if @filename
            @roll_type = attrs[:roll_type]
            @roll_param = attrs[:roll_param]
            @caller = attrs[:caller] || 1
            if @roll_type == "file_size" && @roll_param && (@roll_param = @roll_param.to_s)
                size = nil
                if @roll_param.index("K")
                    size = @roll_param.to_i * 1024
                elsif @roll_param.index("M")
                    size = @roll_param.to_i * 1024 * 1024
                end
                @roll_param = size
            end
            @level = LEVELS.index(attrs[:level].upcase) || 1
            @last_log_time = nil
        end


        def self.loggers
            return LOGGERS
        end

        def self.add_log(logger)
            LOGGERS << logger
        end

        def self.get(name)
            LOGGERS.each do |__log__|
                if __log__.name == name
                    return __log__
                end
            end
        end

        attr_writer :caller

        def rename_and_create_new(newfilename)
            # fix Error::EACCESS exception throw when file is opened before rename by lyf
            begin
                FileUtils.cp(@file.path, newfilename)
                @file.flush
                @file.close
                FileUtils.rm_f(@file.path)
                sleep 2
                @file.reopen(@file.path, "w")
            rescue Exception => e
                puts "error when try to  rename_and_create_new #{newfilename}"
            end
            #unless (FileUtils.cp(@file.path, newfilename) and FileUtils.rm_f(@file.path) and @file.reopen(@file.path, "w"))
            #    #puts "==> error rename #{@filename} => #{newfilename}"
            #end
        end

        def check_split_file
            if @roll_type == "daily"
                if @last_log_time && @last_log_time.day != Time.now.day
                    p = @file.path
                    new_name = nil
                    if p.rindex(".") > p.rindex("/")
                        new_name = "#{p[0, p.rindex(".")]}.#{@last_log_time.strftime("%Y-%m-%d")}#{p[p.rindex("."), p.length]}"
                    else
                        new_name = "#{p}.#{@last_log_time.strftime("%Y-%m-%d")}"
                    end
                    rename_and_create_new(new_name)
                end
            elsif @roll_type == "file_size"
                if File.size(@file) >= @roll_param
                    p = @file.path
                    new_name = nil
                    if p.rindex(".") > p.rindex("/")
                        new_name = "#{p[0, p.rindex(".")]}.#{Time.now.strftime("%Y%m%d%H%M")}#{p[p.rindex("."), p.length]}"
                    else
                        new_name = "#{p}.#{Time.now.strftime("%Y%m%d%H%M")}"
                    end
                    rename_and_create_new(new_name)
                end
            end
        end

        def truncate
            @file.truncate(0)
            @file.flush
        end

        def log(_level, msg, err = nil)
            check_split_file if @file
            err_msg = nil
            if caller[@caller].respond_to? :gsub
                line = caller[@caller].gsub(ConfigManager.root, '')
                line = caller[@caller + 2].gsub(ConfigManager.root, '') if line.include? '/Util/diy-pcap/diy/logger.rb'
            else
                line = caller[1].gsub(ConfigManager.root, '')
            end
            _msg = "#{_level}#{Time.now.strftime("%y-%m-%d %H:%M:%S")}\n#{line}: #{msg}"
            _msg += "\n" if _msg[-1] != "\n"
            if $stdouttype== "GBK"
                _msg = _msg.to_gbk
            end
            my_puts _msg, COLORS[_level.strip] if @stdout
            @file.puts _msg if @file
            _msg = "#{err.message}\t#{err.backtrace.join("\n\t")}" if err
            my_puts _msg, COLORS[_level.strip] if err && @stdout
            @file.puts _msg if err && @file
            @file.dup if @file
            @last_log_time = Time.now
        end

        def soft(*msg)
            log("SOFT ", msg.join(','), nil) if true
        end

        def debug(msg, err = nil)
            log("DEBUG ", msg, err) if @level == 0
        end

        def info(msg, err = nil)
            log("INFO  ", msg, err) if @level <= 1
        end

        def warn(msg, err = nil)
            log("WARN  ", msg, err) if @level <= 2
        end

        def error(msg, err = nil)
            log("ERROR ", msg, err) if @level <= 3
        end

        def fatal(msg, err = nil)
            log("FATAL ", msg, err)
        end

        def debug?
            @level == 0
        end

        def info?
            @level >= 1
        end

        def add(*)
        end
    end


    class SingleLogger
        def self.get_conf
            @@logger_config ||= YAML.load_file(File.expand_path(File.join(ConfigManager.root, 'config', 'logger.yml')))
            @@logger_config
        end

        key = get_conf['default']
        @@mylogger ||= MyLogger.new({ :stdout => get_conf[key]["stdout"], :name => key,
                                      :file => File.join(ConfigManager.root, get_conf[key]["file"]),
                                      :roll_type => get_conf[key]["roll_type"],
                                      :roll_param => get_conf[key]["roll_param"],
                                      :level => get_conf[key]["level"],
                                      :caller => 2 })

        def self.new(*args)
            @@mylogger || super(*args)
        end

        def self.get_logger
            @@mylogger || self.new()
        end

        def initialize(*args)
            @@mylogger || super(*args)
        end


        def self.method_missing(*arg)
            @@mylogger.send(*arg)
        end
    end
    module ToolLogger
        def log(*arg)
            SingleLogger.get_logger.log(*arg)
        end

        def warn(*arg)
            SingleLogger.get_logger.warn(*arg)
        end

        def debug(*arg)
            SingleLogger.get_logger.debug(*arg)
        end

        def error(*arg)
            SingleLogger.get_logger.error(*arg)
        end

        def fatal(*arg)
            SingleLogger.get_logger.fatal(*arg)
        end

        module_function :log, :warn, :debug, :error, :fatal

        def method_missing(*arg)
            SingleLogger.get_logger.send(*arg)
        end

        def self.method_missing(*arg)
            SingleLogger.get_logger.send(*arg)
        end
    end
end
#TestTool::ToolLogger.error("123")
