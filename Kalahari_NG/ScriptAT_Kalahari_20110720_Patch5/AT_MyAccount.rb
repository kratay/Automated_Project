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
	include Selenium::Client::Vendaqa::MyAccount
	def setup

		@verification_errors = []
		@session = Selenium::Client::Driver.new \
			:host => $gsHost,
			:port => $giPort,
			:browser => $gsBrowser,
			:url => $gsURL,
			:timeout_in_second => $giTimeOut
		@session.start_new_browser_session('commandLineFlags' => '--disable-web-security')	
		@session.open "/page/home"
		@session.wait_for_page_to_load
		@session.window_maximize
		
	end

	def teardown
			#@seleniumnew.closeBrowser
		assert_equal [], @verification_errors
	
	end

	def test_untitled
		#self.selectRegion
		if @session.element?($LoctMyacct)==true
			@session.click($loctGotoLogout)
		end

		#******************** Edit My Account********************#
		self.registerAndBoughtItem
		self.click($loctGotoLogout)
		self.loginEditMyAccount	
		self.editMyAccount("Blank field", false,"MA-02")
		self.editMyAccount("Text in phone field ", false, "MA-03")
		self.editMyAccount("Entry valid data ", true, "MA-04")
		self.click($loctGotoLogout)
		sleep 3
		
		#******************** Order history ********************#
		#self.registerAndBoughtItem
		self.loginEditMyAccount
		self.myAccountAndHistory
		self.orderHistoryVerify
		self.click($loctGotoLogout)

		#******************** Account Details ********************#
		self.loginEditMyAccount
		self.accountDetailEditPWD
		self.accountDetailEditPWDVerfiy("Blank field",false, "MA-10")
		self.accountDetailEditPWDVerfiy("Edit wrong password ",false, "MA-11")
		self.accountDetailEditPWDVerfiy("Edit correct password ",true, "MA-12")
		self.click($loctGotoLogout)

		self.loginEditMyAccount
		self.editCommunicationOptions
		self.click($loctGotoLogout)
		self.loginEditMyAccount
		#self.editProfile # not required for kalahari 
		#self.click($loctGotoLogout) # not required for kalahari 
		#self.loginEditMyAccount # not required for kalahari 
		self.addressBook
		self.addNewAddress("Blank field", false, "MA-21")
		self.addNewAddress("Text in phone field", false, "MA-22")
		self.addNewAddress("Entry valid data", true, "MA-23")
		self.click($loctGotoLogout)
		self.loginEditMyAccount
		self.goReminders
		self.addReminders("Blank field", false,"","MA-27")
		self.addReminders("To verify that reminders is working properly. - invalid year", false, "5331", "MA-28")
		self.addReminders("To verify that add a reminders is working properly. - valid year", true, "1983", "MA-29")
		self.click($loctGotoLogout)
		self.loginEditMyAccount
		self.viewReminders
		self.editReminders
		self.writeResult("MA-END" , "Finsished to execute", "Done", "Finished")
			
	    begin
	        assert self.is_text_present("ERROR::")
	    rescue #Test::Unit::AssertionFailedError
	        @verification_errors << $!
	    end				
	end
  
end
