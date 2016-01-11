require 'rubygems'
require 'selenium-webdriver'
require 'minitest/autorun'
require 'yaml'

require_relative 'helpers/base_test'
require_relative 'helpers/navigation_helpers'
require_relative 'helpers/login_helpers'
require_relative 'helpers/dashboard_helpers'

BROWSER = 'firefox'

class Autogram < Minitest::Test
    def setup
        @test_beginning_time = Time.now
        puts "Running Setup"
        @properties = YAML.load_file("config/properties.yml")
        @uris = YAML.load_file("config/uris.yml")
        #@friends = YAML.load_file("config/friendlist.yml")
        #@pending = YAML.load_file("config/pending.yml")
        @blacklist = YAML.load_file("config/blacklist.yml")
        @driver = configure_driver(BROWSER)
        @domain = 'http://www.instagram.com'
        @wait = set_explicit_wait(20)
    end

    def test_login
        puts "Login Test:"
        navigate_to_login(@driver, @domain, @uris)

        puts "Logging in with valid email and password"
        login(@driver, @properties['test_account']['username'], @properties['test_account']['password'])
        assert(@driver.find_elements(:xpath => '//*[contains(.,"' + @properties['test_account']['username'] + '")]'), "FAILURE: Username not appearing on page")
        @driver.navigate.refresh if seeding_followers?(@driver)
        load_more(@driver)
        load_more(@driver)
        load_more(@driver)
        load_more(@driver)
    end

    def teardown
        save_last_run(@properties)
        puts "Test took #{humanize_time(Time.now - @test_beginning_time)} to run"
        @driver.quit
    end
end