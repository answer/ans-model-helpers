# vi: set fileencoding=utf-8

shared_examples_for "Ans::Model::Helpers::BelongsTo" do
  describe "belongs_to" do
    before do
      @target ||= Object.const_get(@scope_name.to_s.camelize).find Fabricate(@scope_name).id
      @item ||= Fabricate(model.to_s.underscore.to_sym, :"#{@scope_name}_id" => @target.id)
    end
    it "は、対象のモデルインスタンスを返す" do
      @item.send(@scope_name).should == @target
    end
  end
end

shared_examples_for "Ans::Model::Helpers::HasOne" do
  describe "has_one" do
    before do
      @item ||= Fabricate(model.to_s.underscore.to_sym)
      @owner ||= Object.const_get(@scope_name.to_s.camelize).find Fabricate(@scope_name, :"#{model.to_s.underscore}_id" => @item.id).id
    end
    it "は、対象のモデルインスタンスを返す" do
      @item.send(@scope_name).should == @owner
    end
  end
end

shared_examples_for "Ans::Model::Helpers::Sql" do
  describe "scope" do
    before do
      @scope_params ||= []
      @sql_params ||= {}
    end
    it "は、指定された sql を返す" do
      model.send(@scope_name, *@scope_params).to_sql.should == @sql.call(@sql_params)
    end
    it "は、実行可能である" do
      model.send(@scope_name, *@scope_params).each{break}
    end
  end
end

shared_examples_for "Ans::Model::Helpers::HasManySql" do
  describe "has_many" do
    before do
      @item ||= Fabricate(model.to_s.underscore.to_sym)
      @sql_params ||= {}
    end
    it "は、指定された sql を返す" do
      @item.send(@scope_name).scoped.to_sql.should == @sql.call(@sql_params)
    end
    it "は、実行可能である" do
      @item.send(@scope_name).each{break}
    end
  end
end
