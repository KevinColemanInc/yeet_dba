RSpec.describe YeetDba::MissingForeignKeys do
  before { YeetDba::MissingForeignKeys.instance_variable_set(:@config, nil) }

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

  describe '.tables' do
    it 'removes ignored tables' do
      expect(YeetDba::MissingForeignKeys).to receive(:ignored_tables).and_return(['ar_internal_metadata'])
      expect(YeetDba::MissingForeignKeys.tables).not_to include('ar_internal_metadata')
    end
  end

  describe '.ignored_columns' do
    let(:configuration) do
      {'exclude_columns' => {"mytable": ["mycolumn"]} }
    end

    let(:empty_configuration) do
      {'exclude_columns' => nil }
    end

    let(:no_configuration) do
      {}
    end


    it 'returns array of tables' do
      expect(YeetDba::MissingForeignKeys).to receive(:config).and_return(configuration)
      expect(YeetDba::MissingForeignKeys.ignored_columns).to eq({"mytable": ["mycolumn"]})
    end

    it 'returns empty array for empty config' do
      expect(YeetDba::MissingForeignKeys).to receive(:config).and_return(empty_configuration)
      expect(YeetDba::MissingForeignKeys.ignored_columns).to eq({})
    end

    it 'return empty array for no config' do
      expect(YeetDba::MissingForeignKeys).to receive(:config).and_return(no_configuration)
      expect(YeetDba::MissingForeignKeys.ignored_columns).to eq({})
    end
  end

  describe '.ignored_tables' do
    let(:configuration) do
      {'exclude_tables' => ['table_to_be_ignored'] }
    end

    let(:empty_configuration) do
      {'exclude_tables' => nil }
    end

    let(:no_configuration) do
      {}
    end

    it 'returns array of tables' do
      expect(YeetDba::MissingForeignKeys).to receive(:config).and_return(configuration)
      expect(YeetDba::MissingForeignKeys.ignored_tables).to eq(['table_to_be_ignored'])
    end

    it 'returns empty array for empty config' do
      expect(YeetDba::MissingForeignKeys).to receive(:config).and_return(empty_configuration)
      expect(YeetDba::MissingForeignKeys.ignored_tables).to eq([])
    end

    it 'return empty array for no config' do
      expect(YeetDba::MissingForeignKeys).to receive(:config).and_return(no_configuration)
      expect(YeetDba::MissingForeignKeys.ignored_tables).to eq([])
    end
  end

  describe '.config' do
    it 'loads .yeet_dba.yml' do
      expect(YeetDba::MissingForeignKeys.config).to eq(
        {'exclude_tables' => ['table_to_be_ignored'] }
      )
    end

    it 'empty object when no file exists' do
      expect(File).to receive(:exist?).with(Pathname.new(Rails.root).join('.yeet_dba.yml')).and_return(false)
      expect(YeetDba::MissingForeignKeys.config).to eq({})
    end
  end
end
