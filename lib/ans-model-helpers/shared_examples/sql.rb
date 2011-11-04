# vi: set fileencoding=utf-8

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
