# encoding: UTF-8
# 项目配置
AppConfig = ::YAML.load_file(APP_CONFIG_PATH)[ENV["RACK_ENV"]] if File.exists?(APP_CONFIG_PATH)
