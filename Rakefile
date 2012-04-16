require 'logger'
require 'mechanize'
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
    browser = Mechanize.new
    base_url = 'http://www.programmableweb.com'
    set1 = browser.get("#{base_url}//apis/directory/1?sort=category").search('table.listTable tr').select{|tr| tr.children.first.name.eql?('td')}
    set2 = browser.get("#{base_url}//apis/directory/2?sort=category").search('table.listTable tr').select{|tr| tr.children.first.name.eql?('td')}
    set1.concat(set2).each do |api|
      name = api.children[0].children.first.text
      url = api.children[0].children.first['href']
      description = api.children[1].text
      category = api.children[2].text
      Api.create :name => name, :url => url, :description => description, :category => category
    end
  end
  
end