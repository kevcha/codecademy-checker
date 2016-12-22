require "json"

module Codeacademy
  class Skill
    attr_reader :title, :time_ago_in_words

    def initialize(title, time_ago_in_words)
      @title = title
      @time_ago_in_words = time_ago_in_words
    end

    def to_json(args = {})
      {
        title: @title,
        time_ago_in_words: @time_ago_in_words
      }.to_json
    end

    def to_xml(options = {})
      options[:builder].tag!("badge",
        title,
        { time_ago_in_words: @time_ago_in_words }
      )
    end
  end
end
