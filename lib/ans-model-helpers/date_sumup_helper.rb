# vi: set fileencoding=utf-8

module Ans::Model::Helpers
  module DateSumupHelper
    def self.included(mod)
      mod.class_eval do
        scope :date_in, lambda{|p|
          date_column_in date_column, p
        }
        scope :date_column_in, lambda{|column,p|
          case
          when p[:day]
            from = to = p[:day]
          else
            from, to = p[:from], p[:to]
          end

          result = scoped

          case column
          when Array
            tables = column.dup
            column = tables.pop

            tables.each do |table|
              result = result.joins table
            end
          end

          result
          .where("#{column} >= ?", from.beginning_of_day)
          .where("#{column} <= ?", to.end_of_day)
        }
      end

      class << mod
        def day_in(p)
          day_column_in date_column, p
        end
        def day_column_in(date_column,p)
          unless p[:day]
            day = DateTime.now.beginning_of_day
          else
            begin
              day = DateTime.parse(p[:day])
            rescue ArgumentError
              day = DateTime.now.beginning_of_day
            end
          end

          [
            date_column_in(date_column, day: day),
            day.strftime("%Y-%m-%d"),
          ]
        end
        def days_in(p)
          days_column_in date_column, p
        end
        def days_column_in(date_column,p)
          case
          when p[:from] && p[:to]
            begin
              from = DateTime.parse(p[:from])
            rescue ArgumentError
              from = DateTime.now
            end
            begin
              to = DateTime.parse(p[:to])
            rescue ArgumentError
              to = from
            end
          else
            unless p[:month]
              from = DateTime.now.beginning_of_month
            else
              begin
                from = DateTime.parse(p[:month])
              rescue ArgumentError
                from = DateTime.now.beginning_of_month
              end
            end
            to = (from >> 1) - 1
          end

          [
            [].tap{|dates|
              from.upto(to) do |day|
                dates << [day, date_column_in(date_column,day: day)]
              end
            },
            date_column_in(date_column,from: from, to: to),
            [from, to].map{|day| day.strftime("%Y-%m-%d")},
          ]
        end
      end
    end
  end
end
