ActiveRecord::Schema.define do
  create_table 'users', force: true do |t|
  end

  create_table 'companies', force: true do |t|
    t.column 'owned_id', :integer
    t.column 'country_id', :integer
  end

  add_index :companies, :country_id

  create_table 'profiles', force: true do |t|
    t.column 'user_id', :integer
  end

  create_table 'companies_users', force: true do |t|
    t.column 'user_id', :integer
    t.column 'company_id', :integer
  end
end