require 'csv'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    restore_users
  end  
  
end

def restore_users
  filename = "../geneva_userdata.csv"

  if File.exists?(filename) 
    puts "Loading Users From File #{filename}"

    bpastHeader = false
    
    CSV.foreach(filename) do |row|
      if !bpastHeader
        bpastHeader = true
        next
      end
    
      sPassword = "password"
      
      if row[1].blank? || row[3].blank?
        sval = row[0].split(' ')
        row[1] = sval[0]
        row[3] = sval[1]
      end
      
      aHost = User.create!(:name => row[0],
                         :fname => row[1],
                         :midinit => row[2],
                         :lname => row[3],
                         :email => row[4],
                         :homephone => row[6],
                         :cellphone => row[7],
                         :street => row[8],
                         :city => row[9],
                         :state => row[10],
                         :zip => row[11],
                         :startdate => row[12],                           
                         :password => "#{sPassword}",
                         :password_confirmation => "#{sPassword}") 
      if row[13] == "true"
        aHost.toggle!(:admin)
      end  

      puts "imported user: " + row[0]            
    end # CSV
  else
    fail "User data file not found."
  end # if file exists  
end
