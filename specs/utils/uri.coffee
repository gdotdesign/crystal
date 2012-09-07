describe 'URI', ->
  it 'should parse url', ->
    uri = new Crystal.Utils.URI('http://test.com?a=b#test')
    expect(uri.toString()).toBe 'http://test.com?a=b#test'