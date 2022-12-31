describe SecretString do

  context 'with a silenced string' do

    subject(:secret) { described_class.new('MySecret', silenced_str: 'SilencedString') }

    it 'silences using to_s' do
      expect(secret.to_s).to eq 'SilencedString'
    end

    it 'silences using inspect' do
      expect(secret.inspect).to eq '"SilencedString"'
    end

    it 'reveals using to_unprotected' do
      expect(secret.to_unprotected).to eq 'MySecret'
    end

    it 'erases the data in memory' do
      secret.erase
      expect(secret.to_unprotected).not_to eq 'MySecret'
    end

    it 'equals correctly with a string having the same content' do
      expect(secret).to eq 'MySecret'
    end

    it 'matches correctly with a string having the same content' do
      expect(secret).to match(/Secret/)
    end

    it 'matches correctly using the =~ operator with a string having the same content' do
      expect(secret =~ /Secret/).not_to be_nil
    end

    it 'reports the correct size' do
      expect(secret.size).to eq 'MySecret'.size
    end

  end

  context 'with a silenced frozen string' do

    it 'fails to initialize a secret string frozen' do
      expect { described_class.new('MySecret'.freeze, silenced_str: 'SilencedString') }.to raise_error 'Can\'t silence a frozen string'
    end

  end

  describe 'erase' do

    it 'erases a String' do
      str = 'MySecret'
      described_class.erase(str)
      expect(str).not_to eq 'MySecret'
    end

    it 'fails to erase a frozen String' do
      str = 'MySecret'.freeze
      expect { described_class.erase(str) }.to raise_error 'Can\'t erase a frozen string'
    end

  end

  describe 'protect' do

    it 'protects a String' do
      str = 'MySecret'
      described_class.protect(str, silenced_str: 'SilencedString') do |secret_string|
        expect(secret_string.to_s).to eq 'SilencedString'
        expect(secret_string.to_unprotected).to eq 'MySecret'
        expect(str.to_s).to eq 'MySecret'
      end
      expect(str.to_s).not_to eq 'MySecret'
    end

    it 'fails to protect a frozen String' do
      str = 'MySecret'.freeze
      called = false
      expect do
        described_class.protect(str, silenced_str: 'SilencedString') do
          called = true
        end
      end.to raise_error 'Can\'t protect a frozen string'
      expect(called).to be false
    end

  end

end
