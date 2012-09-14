describe "Request", ->
  if window.location.hash is "#phantom"
    types = ['get','post']
  else
    types = ['get','post','put','delete','patch']
  types.forEach (type) ->
    describe type, ->
      it 'should return Response', ->
        runs =>
          request = new Request('/xhr')
          @response = null
          request[type] null, (resp) =>
            @response = resp
        waitsFor ->
          !!@response
        , 'No response', 1000
        runs =>
          expect(@response).not.toBe(null)
          expect(@response.body).toBe type.toUpperCase()

      it 'should send data', ->
        runs =>
          request = new Request('/xhr')
          @response = null
          @data = String.random(10)
          request[type] {random: @data}, (resp) =>
            @response = resp
        waitsFor ->
          !!@response
        , 'No response', 1000
        runs =>
          expect(@response).not.toBe(null)
          data = JSON.parse(@response.body)
          expect(data.random).toBe @data

      types =
        js: ['text/javascript', String]
        html: ['text/html', DocumentFragment]
        JSON: ['text/json', Object]
        XML: ['text/xml', String]

      for key,value of types
        do (key, value) ->
          it 'should parse response based on Content-Type', =>
            runs =>
              request = new Request('/xhr.'+key.toLowerCase())
              @response = null
              @data = String.random(10)
              request[type] {random: @data}, (resp) =>
                @response = resp
            waitsFor =>
              !!@response
            , 'No response', 1000
            runs =>
              expect(@response.headers['Content-Type']).toBe value[0]
              if value[1] is String
                expect(typeof @response.body).toBe 'string'
              else
                expect(@response.body instanceof value[1]).toBe true
              key = "script" if key is "js"
              expect(@response["is"+key.capitalize()]()).toBe true
