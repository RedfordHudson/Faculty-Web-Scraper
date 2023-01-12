require 'watir'
require 'google_drive'

def scrape(browser,worksheet)

    keys = ['area','name','email','office','phone','website']
    keys.each_with_index{ |key,index| worksheet[1,index+1] = key }

    Watir.default_timeout = 5

    base_URL = 'https://www.cs.uci.edu/cs-research-areas/'

    browser.goto base_URL

    areas = browser.div(class:'elementor-toggle').children
    
    faculty_links = []
    
    areas.each_with_index{ |area,index|
        area.click
        
        faculty_links << [area.child.text, area.div(class:'elementor-tab-content').uls[index == 14 ? 1 : 0].lis.map{|li| [li.a.href,li.text] } ]
    }

    row = 1

    faculty_links.each{ |area_name, links|

        links.each{ |link,name|
            browser.goto link

            begin
                # name = browser.h2(class:'fac-pro-name').text
                email,office,phone,fax,website = browser.table.child.children.map{|tr| tr.tds[1].text}
            rescue
                email,office,phone,fax,website = nil
            else
            ensure
                [area_name,name,email,office,phone,website].each_with_index{ |value,column| worksheet[row+1,column+1] = value}
                worksheet.save

                row += 1
            end
        }
    } 
end

path = 'C:\Browser Drivers\chromedriver.exe'
Selenium::WebDriver::Chrome::Service.driver_path = path
browser = Watir::Browser.new :chrome

spreadsheet_key = '12eCPkNbizfkSA4y9WtFCE6IJIiPWZKbrc4Zo9iQ9mYA'
session = GoogleDrive::Session.from_config('./config.json')
worksheet = session.spreadsheet_by_key(spreadsheet_key).worksheets[0]

scrape browser,worksheet