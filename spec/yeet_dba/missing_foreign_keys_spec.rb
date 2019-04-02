RSpec.describe YeetDba::MissingForeignKeys do
  it 'finds missing foreign keys' do
    missing_foreign_keys = [%w[user_id profiles users],
                            %w[user_id companies_users users],
                            %w[company_id companies_users companies]]
    expect(YeetDba::MissingForeignKeys.foreign_keys).not_to be_empty

    YeetDba::MissingForeignKeys.foreign_keys.each_with_index do |f_k, i|
      expect(f_k.column).to eq missing_foreign_keys[i][0]
      expect(f_k.table_a).to eq missing_foreign_keys[i][1]
      expect(f_k.table_b).to eq missing_foreign_keys[i][2]
    end
  end
end
