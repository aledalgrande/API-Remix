require 'logger'
require 'mechanize'
require 'active_support/core_ext'
require './api-remix'

namespace :db do

  desc "Migrate the database"
  task(:migrate) do
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate")
  end

  desc 'Rolls the schema back to the previous version. Specify the number of steps with STEP=n'
  task(:rollback) do
    step = ENV['STEP'] ? ENV['STEP'].to_i : 1
    version = ActiveRecord::Migrator.current_version - step
    ActiveRecord::Migrator.migrate('db/migrate/', version)
  end

end

namespace :api do
  
  desc "Import APIs"
  task :import do
    Api.destroy_all
    browser = Mechanize.new
    base_url = 'http://www.programmableweb.com'
    set1 = browser.get("#{base_url}//apis/directory/1?sort=category").search('table.listTable tr').select{|tr| tr.children.first.name.eql?('td')}
    set2 = browser.get("#{base_url}//apis/directory/2?sort=category").search('table.listTable tr').select{|tr| tr.children.first.name.eql?('td')}
    set1.concat(set2).each do |api|
      begin
        name = fix_string api.children[0].children.first.text
        url = fix_string api.children[0].children.first['href']
        description = fix_string api.children[1].text
        category = fix_string api.children[2].text
        p name
        Api.create :name => name, :url => url, :description => description, :category => category
      rescue
        p "#{api.children[0].children.first.text} has shitty characters!"
      end
    end
  end
  
end

def fix_string(string)
  Iconv.new('UTF-8//IGNORE', 'UTF-8').iconv(string).squish!
end