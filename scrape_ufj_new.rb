require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'

Capybara.configure do |config|
  config.run_server = false
  config.current_driver = :poltergeist
  config.javascript_driver = :poltergeist
  config.app_host = "http://direct.bk.mufg.jp/"
  config.default_wait_time = 5
end

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {:timeout=>120, js_errors: false})
end

module Scraper
  class ScraperUfj
    include Capybara::DSL

    def initialize(userID, password)
      @userID = userID
      @password = password
    end

    def open_loginpages
      page.driver.headers = { "User-Agent" => "Mac Safari" }
      visit('')
      find(:xpath, "//*[@class='mt5']/a/img[contains(./@alt, 'ログイン')]").click
    end

    def balance_get
      switch_to_window { title == 'ログイン - 三菱東京ＵＦＪ銀行' }

      keiyaku_input = find(:xpath, "//input[@type='text']")
      keiyaku_input.native.send_key(@userID)
      password_input = find(:xpath, "//input[@type='password']")
      password_input.native.send_key(@password)

      # click_link "ログイン"
      find(:xpath, "//p[@class='acenter admb_m']/a/img[contains(./@alt, 'ログイン')]").click
      puts find(:xpath, "//td[@class='number']").text
    end
  end
end

scraper = Scraper::ScraperUfj.new('あなたの契約番号', 'あなたのパスワード')
scraper.open_loginpages
scraper.balance_get
