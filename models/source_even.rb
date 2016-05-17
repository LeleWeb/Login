# encoding: UTF-8
class SourceEven < ActiveRecord::Base
  serialize :source_msg, Hash
  serialize :even_extend, Hash

end
