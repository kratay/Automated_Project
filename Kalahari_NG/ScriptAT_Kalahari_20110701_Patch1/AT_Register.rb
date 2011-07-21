require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"
require "selenium/client/idiomatic"
require "selenium/client/vendaqa/info"
require "selenium/client/vendaqa/customer"
require "selenium/client/vendaqa/commons"



class Untitled <  Test::Unit::TestCase	  

	include Selenium::Client::Vendaqa::Commons
	
	def setup

		@verification_errors = []
		#@selenium = Selenium::Client::Vendaqa::Customer.new \
		#	:mainfunction => "Register" 
		#@selenium.connectBrowser #($gsHost, $gsPort, $gsBrowser, $gsURL, $giTimeOut)
		
		#@selenium = self.connectBrowser
		@seleniumnew = Selenium::Client::Vendaqa::Customer.new \
			:mainfunction => "Register"
		
		@seleniumnew.connectBrowser
			
	end

	def teardown
		#@seleniumnew.closeBrowser
		assert_equal [], @verification_errors
	end

	def test_untitled
		@seleniumnew.selectRegion
		####### 2 test case are lost from New Customer because no valid in E-Mail box ####### 
		@seleniumnew.testRegisterNewCust	
		@seleniumnew.testRegister		
		@seleniumnew.testForgotPass
	

	    begin
	        assert @seleniumnew.is_text_present("ERROR::")
	    rescue #Test::Unit::AssertionFailedError
	        @verification_errors << $!
	    end				
	end
  
end
