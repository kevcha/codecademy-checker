require "json"

module Codeacademy
  class Badge
    attr_reader :achievement_type, :title, :date

    def initialize(achievement_type, title, date)
      @achievement_type = achievement_type
      @title = title
      @date = date
    end

    def to_json(args = {})
      {
        title: @title,
        date: @date
      }.to_json
    end

    def to_xml(options = {})
      options[:builder].tag!("badge",
        title,
        { date: @date }
      )
    end
  end
end
