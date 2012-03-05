# vi: set fileencoding=utf-8

module Ans::Model::Helpers
  module SqlSpecHelper
    def scope_は(scope_name)
      @scope_name = scope_name
    end
    def scope_の引数は(*params)
      @scope_params = params
    end

    alias_method :"method_は", :"scope_は"
    alias_method :"method_の引数は", :"scope_の引数は"

    alias_method :"scope_is", :"scope_は"
    alias_method :"scope_param_is", :"scope_の引数は"

    alias_method :"method_is", :"scope_は"
    alias_method :"method_param_is", :"scope_の引数は"

    def item_を作成(*args)
      case
      when defined? FactoryGirl
        FactoryGirl.create(*args)
      when defined? Fabricate
        Fabricate(*args)
      end
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

    alias_method :"create_item", :"item_を作成"
    alias_method :"sql_should_be", :"sql_は"
    alias_method :"sql_param_is", :"sql_の引数は"

    def has_many_sql
      proc{|sql|
        sql <<  "SELECT"
        sql <<   " `#{@scope_name}`.*"
        sql << " FROM"
        sql <<   " `#{@scope_name}`"
        sql << " WHERE"
        # acts_as_paranoid に対応
        sql <<   " (#{@scope_name}.deleted_at IS NULL) AND" if @item.respond_to? :deleted_at
        sql <<   " (`#{@scope_name}`.#{model.to_s.underscore}_id = #{@item.id})"
      }
    end

    def has_many_through_sql(through)
      proc{|sql|
        sql <<  "SELECT"
        sql <<   " `#{@scope_name}`.*"
        sql << " FROM"
        sql <<   " `#{@scope_name}`"
        sql << " INNER JOIN"
        sql <<   " `#{through}`"
        sql <<   " ON `#{@scope_name}`.id = `#{through}`.#{@scope_name.to_s.singularize}_id"
        sql << " WHERE"
        # acts_as_paranoid に対応
        sql <<   " (#{@scope_name}.deleted_at IS NULL) AND" if @item.respond_to? :deleted_at
        sql <<   " ((`#{through}`.#{model.to_s.underscore}_id = #{@item.id}))"
      }
    end

  end
end
