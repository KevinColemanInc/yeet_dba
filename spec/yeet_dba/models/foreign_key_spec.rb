RSpec.describe YeetDba::ForeignKey do
  it 'can be created' do
    expect(YeetDba::ForeignKey.new(table_a: 'users',
      table_b: 'profiles', 
      column: 'user_id')).to be_truthy
  end
end
