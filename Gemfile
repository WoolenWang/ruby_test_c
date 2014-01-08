source 'http://ruby.taobao.org'
# 使用 guard-rspec来自动测试
gem 'guard-rspec', '4.2.0'
# 使用spork来加速自动测试
gem 'spork', '0.9.2'
# 使用guard-spork来关联两者
gem 'guard-spork', '1.5.1'
# 使用notify来通知, 自动区分各个平台
case RUBY_PLATFORM
    when /mswin|msys|mingw|cygwin|bccwin|wince|emc/ # 这里是windows，貌似好多种可能的编译器出来的，现在大多都是mingw的了
        gem 'rb-fchange'
        gem 'rb-notifu'
        gem 'win32console'
    when /linux/ # 这里是linux的
        gem 'rb-inotify', '0.9.3'
        gem 'libnotify', '0.8.2'
    else # 这里是mac的
        gem 'rb-fsevent'
        gem 'growl'
end
