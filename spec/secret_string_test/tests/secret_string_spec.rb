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

  end

  describe 'erase' do

    it 'erases a String' do
      str = 'MySecret'
      described_class.erase(str)
      expect(str).not_to eq 'MySecret'
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

  end

end
