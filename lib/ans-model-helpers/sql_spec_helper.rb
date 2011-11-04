# vi: set fileencoding=utf-8

module Ans::Model::Helpers
  module SqlSpecHelper
    def scope_は(scope_name)
      @scope_name = scope_name
    end
    def scope_の引数は(*params)
      @scope_params = params
    end
    def sql_は
      @sql = proc{|params|
        params ||= {}
        "".tap{|sql|
          yield sql, params
        }
      }
    end
    def sql_の引数は(params)
      @sql_params = params
    end
  end
end
