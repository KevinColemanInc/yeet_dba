RSpec.describe YeetDba::InvalidColumn do
  it '#to_s' do
    verify_data = YeetDba::VerifyData.new(column: nil)
    allow(verify_data).to receive(:orphaned_rows_count) { 3 }

    table_name = 'users'
    association_table_name = 'profiles'
    column_name = 'user_id'
    column = OpenStruct.new(association_table_name: association_table_name,
      db_column: OpenStruct.new(name: column_name))

    invalid_column = YeetDba::InvalidColumn.new(table_name: table_name,
      column: column,
      verify_data: verify_data)
    
    out = invalid_column.to_s
    expect(out).to include table_name
    expect(out).to include association_table_name
    expect(out).to include 3.to_s
    expect(out).to include column_name
  end
end
