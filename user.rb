require 'open-uri'
require 'nokogiri'
require 'net/http'
require 'mechanize'
require_relative 'badge'

module Codeacademy
  class User
    class UnknownUserError < StandardError; end

    def initialize(username)
      @username = username
    end

    def exist?
      begin
        fetch
        true
      rescue UnknownUserError
        false
      end
    end

    def badges(achievement_type = 'ruby')
      badges = []
      doc = Nokogiri::HTML(fetch)
      doc.css(".achievement-card").each do |element|
        if element.css(".cc-achievement--#{achievement_type}-achievement").any?
          title = element.css('h5').first.text
          date = Date.parse(element.css('small small').first.text)
          badges << Badge.new(achievement_type, title, date)
        end
      end
      badges.sort_by &:date
    end

    private

    def login_url
      "https://www.codecademy.com/login"
    end

    def achievements_url
      "https://www.codecademy.com/users/#{@username}/achievements?locale=en"
    end

    def fetch
      agent = Mechanize.new
      page = agent.get(login_url)

      login_form = page.form
      fail UnknownUserError if login_form.nil?

      login_form.send(:'user[login]=', ENV['CODECADEMY_USERNAME'])
      login_form.send(:'user[password]=', ENV['CODECADEMY_PASSWORD'])

      agent.submit(login_form)
      begin
        page = agent.get(achievements_url)
        page.body
      rescue Mechanize::ResponseCodeError => e
        puts e
        fail UnknownUserError
      end
    end
  end
end
