RSpec.describe YeetDba::Column do
  it '#is_association? - true' do
    column = YeetDba::Column.new(db_column: OpenStruct.new(name: 'user_id'),
      table_name: 'profiles', 
      tables: 'user_id')
      expect(column.is_association?).to be_truthy
  end

  it '#is_association? - false' do
    column = YeetDba::Column.new(db_column: OpenStruct.new(name: 'kitten'),
      table_name: 'profiles', 
      tables: 'user_id')
      expect(column.is_association?).to be_falsey
  end
end
