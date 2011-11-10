# vi: set fileencoding=utf-8

require "ans-model-helpers/shared_examples/sql"

shared_examples_for "Ans::Model::Helpers::DateSumup" do
  describe ".date_in" do
    include Ans::Model::Helpers::SqlSpecHelper

    before do
      scope_は :date_in
      sql_は do |sql,p|
        sql <<  "SELECT"
        sql <<   " `#{table}`.*"
        sql << " FROM"
        sql <<   " `#{table}`"
        sql << " #{date_join}" if respond_to?(:date_join)
        sql << " WHERE"
        sql <<   " (#{date_column} >= '#{p[:from]}') AND (#{date_column} <= '#{p[:to]}')"
      end
    end
    context "指定日の範囲で検索した場合" do
      before do
        scope_の引数は day: DateTime.new(2011, 1, 1)
        sql_の引数は from: "2011-01-01 00:00:00", to: "2011-01-01 23:59:59"
      end
      it_should_behave_like "Ans::Model::Helpers::Sql"
    end
    context "指定範囲で検索した場合" do
      before do
        scope_の引数は from: DateTime.new(2011, 1, 1), to: DateTime.new(2011, 1, 31)
        sql_の引数は from: "2011-01-01 00:00:00", to: "2011-01-31 23:59:59"
      end
      it_should_behave_like "Ans::Model::Helpers::Sql"
    end
  end

  describe ".day_in" do
    context "日付指定無しの場合" do
      it "は、今日の日付で範囲指定したスコープの配列を返す" do
        stub(DateTime).now{DateTime.new(2011,1,10)}
        model.day_in({}).should == [
          model.date_in(day: DateTime.new(2011, 1, 10)),
          "2011-01-10",
        ]
      end
    end
    context "day 指定の場合" do
      it "は、指定した日付で範囲指定したスコープの配列を返す" do
        model.day_in(day: "2011-01-03").should == [
          model.date_in(day: DateTime.new(2011, 1, 3)),
          "2011-01-03",
        ]
      end
    end
  end

  describe ".days_in" do
    context "日付指定無しの場合" do
      it "は、今月の日付で範囲指定したスコープの配列を返す" do
        stub(DateTime).now{DateTime.new(2011,1,10)}
        model.days_in({}).should == [
          [
            [DateTime.new(2011, 1, 1),  model.date_in(day: DateTime.new(2011, 1, 1))],
            [DateTime.new(2011, 1, 2),  model.date_in(day: DateTime.new(2011, 1, 2))],
            [DateTime.new(2011, 1, 3),  model.date_in(day: DateTime.new(2011, 1, 3))],
            [DateTime.new(2011, 1, 4),  model.date_in(day: DateTime.new(2011, 1, 4))],
            [DateTime.new(2011, 1, 5),  model.date_in(day: DateTime.new(2011, 1, 5))],
            [DateTime.new(2011, 1, 6),  model.date_in(day: DateTime.new(2011, 1, 6))],
            [DateTime.new(2011, 1, 7),  model.date_in(day: DateTime.new(2011, 1, 7))],
            [DateTime.new(2011, 1, 8),  model.date_in(day: DateTime.new(2011, 1, 8))],
            [DateTime.new(2011, 1, 9),  model.date_in(day: DateTime.new(2011, 1, 9))],
            [DateTime.new(2011, 1, 10), model.date_in(day: DateTime.new(2011, 1, 10))],
            [DateTime.new(2011, 1, 11), model.date_in(day: DateTime.new(2011, 1, 11))],
            [DateTime.new(2011, 1, 12), model.date_in(day: DateTime.new(2011, 1, 12))],
            [DateTime.new(2011, 1, 13), model.date_in(day: DateTime.new(2011, 1, 13))],
            [DateTime.new(2011, 1, 14), model.date_in(day: DateTime.new(2011, 1, 14))],
            [DateTime.new(2011, 1, 15), model.date_in(day: DateTime.new(2011, 1, 15))],
            [DateTime.new(2011, 1, 16), model.date_in(day: DateTime.new(2011, 1, 16))],
            [DateTime.new(2011, 1, 17), model.date_in(day: DateTime.new(2011, 1, 17))],
            [DateTime.new(2011, 1, 18), model.date_in(day: DateTime.new(2011, 1, 18))],
            [DateTime.new(2011, 1, 19), model.date_in(day: DateTime.new(2011, 1, 19))],
            [DateTime.new(2011, 1, 20), model.date_in(day: DateTime.new(2011, 1, 20))],
            [DateTime.new(2011, 1, 21), model.date_in(day: DateTime.new(2011, 1, 21))],
            [DateTime.new(2011, 1, 22), model.date_in(day: DateTime.new(2011, 1, 22))],
            [DateTime.new(2011, 1, 23), model.date_in(day: DateTime.new(2011, 1, 23))],
            [DateTime.new(2011, 1, 24), model.date_in(day: DateTime.new(2011, 1, 24))],
            [DateTime.new(2011, 1, 25), model.date_in(day: DateTime.new(2011, 1, 25))],
            [DateTime.new(2011, 1, 26), model.date_in(day: DateTime.new(2011, 1, 26))],
            [DateTime.new(2011, 1, 27), model.date_in(day: DateTime.new(2011, 1, 27))],
            [DateTime.new(2011, 1, 28), model.date_in(day: DateTime.new(2011, 1, 28))],
            [DateTime.new(2011, 1, 29), model.date_in(day: DateTime.new(2011, 1, 29))],
            [DateTime.new(2011, 1, 30), model.date_in(day: DateTime.new(2011, 1, 30))],
            [DateTime.new(2011, 1, 31), model.date_in(day: DateTime.new(2011, 1, 31))],
          ],
          model.date_in(from: DateTime.new(2011, 1, 1), to: DateTime.new(2011, 1, 31)),
          ["2011-01-01","2011-01-31"],
        ]
      end
    end
    context "month 指定の場合" do
      it "は、指定した月の日付で範囲指定したスコープの配列を返す" do
        model.days_in(month: "2011-01-01").should == [
          [
            [DateTime.new(2011, 1, 1),  model.date_in(day: DateTime.new(2011, 1, 1))],
            [DateTime.new(2011, 1, 2),  model.date_in(day: DateTime.new(2011, 1, 2))],
            [DateTime.new(2011, 1, 3),  model.date_in(day: DateTime.new(2011, 1, 3))],
            [DateTime.new(2011, 1, 4),  model.date_in(day: DateTime.new(2011, 1, 4))],
            [DateTime.new(2011, 1, 5),  model.date_in(day: DateTime.new(2011, 1, 5))],
            [DateTime.new(2011, 1, 6),  model.date_in(day: DateTime.new(2011, 1, 6))],
            [DateTime.new(2011, 1, 7),  model.date_in(day: DateTime.new(2011, 1, 7))],
            [DateTime.new(2011, 1, 8),  model.date_in(day: DateTime.new(2011, 1, 8))],
            [DateTime.new(2011, 1, 9),  model.date_in(day: DateTime.new(2011, 1, 9))],
            [DateTime.new(2011, 1, 10), model.date_in(day: DateTime.new(2011, 1, 10))],
            [DateTime.new(2011, 1, 11), model.date_in(day: DateTime.new(2011, 1, 11))],
            [DateTime.new(2011, 1, 12), model.date_in(day: DateTime.new(2011, 1, 12))],
            [DateTime.new(2011, 1, 13), model.date_in(day: DateTime.new(2011, 1, 13))],
            [DateTime.new(2011, 1, 14), model.date_in(day: DateTime.new(2011, 1, 14))],
            [DateTime.new(2011, 1, 15), model.date_in(day: DateTime.new(2011, 1, 15))],
            [DateTime.new(2011, 1, 16), model.date_in(day: DateTime.new(2011, 1, 16))],
            [DateTime.new(2011, 1, 17), model.date_in(day: DateTime.new(2011, 1, 17))],
            [DateTime.new(2011, 1, 18), model.date_in(day: DateTime.new(2011, 1, 18))],
            [DateTime.new(2011, 1, 19), model.date_in(day: DateTime.new(2011, 1, 19))],
            [DateTime.new(2011, 1, 20), model.date_in(day: DateTime.new(2011, 1, 20))],
            [DateTime.new(2011, 1, 21), model.date_in(day: DateTime.new(2011, 1, 21))],
            [DateTime.new(2011, 1, 22), model.date_in(day: DateTime.new(2011, 1, 22))],
            [DateTime.new(2011, 1, 23), model.date_in(day: DateTime.new(2011, 1, 23))],
            [DateTime.new(2011, 1, 24), model.date_in(day: DateTime.new(2011, 1, 24))],
            [DateTime.new(2011, 1, 25), model.date_in(day: DateTime.new(2011, 1, 25))],
            [DateTime.new(2011, 1, 26), model.date_in(day: DateTime.new(2011, 1, 26))],
            [DateTime.new(2011, 1, 27), model.date_in(day: DateTime.new(2011, 1, 27))],
            [DateTime.new(2011, 1, 28), model.date_in(day: DateTime.new(2011, 1, 28))],
            [DateTime.new(2011, 1, 29), model.date_in(day: DateTime.new(2011, 1, 29))],
            [DateTime.new(2011, 1, 30), model.date_in(day: DateTime.new(2011, 1, 30))],
            [DateTime.new(2011, 1, 31), model.date_in(day: DateTime.new(2011, 1, 31))],
          ],
          model.date_in(from: DateTime.new(2011, 1, 1), to: DateTime.new(2011, 1, 31)),
          ["2011-01-01","2011-01-31"],
        ]
      end
    end
    context "from, to 指定の場合" do
      it "は、指定した範囲で範囲指定したスコープの配列を返す" do
        model.days_in(from: "2011-01-01", to: "2011-01-10").should == [
          [
            [DateTime.new(2011, 1, 1),  model.date_in(day: DateTime.new(2011, 1, 1))],
            [DateTime.new(2011, 1, 2),  model.date_in(day: DateTime.new(2011, 1, 2))],
            [DateTime.new(2011, 1, 3),  model.date_in(day: DateTime.new(2011, 1, 3))],
            [DateTime.new(2011, 1, 4),  model.date_in(day: DateTime.new(2011, 1, 4))],
            [DateTime.new(2011, 1, 5),  model.date_in(day: DateTime.new(2011, 1, 5))],
            [DateTime.new(2011, 1, 6),  model.date_in(day: DateTime.new(2011, 1, 6))],
            [DateTime.new(2011, 1, 7),  model.date_in(day: DateTime.new(2011, 1, 7))],
            [DateTime.new(2011, 1, 8),  model.date_in(day: DateTime.new(2011, 1, 8))],
            [DateTime.new(2011, 1, 9),  model.date_in(day: DateTime.new(2011, 1, 9))],
            [DateTime.new(2011, 1, 10), model.date_in(day: DateTime.new(2011, 1, 10))],
          ],
          model.date_in(from: DateTime.new(2011, 1, 1), to: DateTime.new(2011, 1, 10)),
          ["2011-01-01","2011-01-10"],
        ]
      end
    end
  end
end
