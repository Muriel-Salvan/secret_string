describe String do

  it 'implements the same API as SecretString: to_unprotected' do
    expect('MySecret'.to_unprotected).to eq 'MySecret'
  end

  it 'implements the same API as SecretString: erase' do
    str = 'MySecret'
    expect { str.erase }.not_to raise_error
    expect(str).to eq 'MySecret'
  end

  it 'equals the unprotected value of a secret string' do
    str = 'MySecret'
    expect(str).to eq SecretString.new('MySecret', silenced_str: 'SilencedString')
  end

end
