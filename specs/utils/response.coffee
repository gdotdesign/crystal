describe 'Response', ->
  describe 'body', ->
    it 'should return documentFragment for text/html', ->
      r = new Response({"Content-Type":"text/html"},"<div></div>",200)
      expect(r.isHtml()).toBe true
      expect(r.body instanceof DocumentFragment).toBe true
      expect(r.body.first().tag).toBe 'div'
    it 'should return object for text/json', ->
      r = new Response({"Content-Type":"text/json"},'{"a":"b"}',200)
      expect(r.isJSON()).toBe true
      expect(typeof r.body).toBe 'object'
      expect(r.body.a).toBe 'b'
    it 'should return node for text/xml', ->
      r = new Response({"Content-Type":"text/xml"},"<a></a>",200)
      expect(r.isXML()).toBe true
      expect(r.body instanceof Node).toBe true
    it 'should return string for text/javascript', ->
      r = new Response({"Content-Type":"text/javascript"},"alert('hello')",200)
      expect(r.isScript()).toBe true
      expect(r.body).toBe "alert('hello')"
  describe 'constructor', ->
    it 'should create a Response', ->
      headers = {}
      body = "test"
      status = 200
      r = new Response(headers,body,status)
      expect(r instanceof Response).toBe true
      expect(r.headers).toBe headers
      expect(r.body).toBe "test"
      expect(r.status).toBe 200