describe  'Store', ->
  if window.location.hash is "#phantom"
    types = {
      LocalStorage: 'LOCAL_STORAGE'
      WebSQL: 'WEB_SQL'
      Memory: 'MEMORY'
    }
  else
    types = {
      LocalStorage: 'LOCAL_STORAGE'
      IndexedDB: 'INDEXED_DB'
      WebSQL: 'WEB_SQL'
      XMLHTTPRequest: 'XHR'
      FileSystem: 'FILE_SYSTEM'
      Memory: 'MEMORY'
    }
  Object.each types, (key, adapter) ->
    describe key, ->
      try
        store = new Store adapter: Store[adapter], prefix: adapter
      if store      
        describe 'get', ->
          it "should retrun false for no key", ->
              runs =>
                store.get 'asd', (success) =>
                  @success = success
              waitsFor ->
                @success isnt undefined
              , 'No response', 1000
              runs =>
                expect(@success).toBe false
          it "should get item", ->
            runs =>
              store.set 'testKey', 'testData', (success) =>
                store.get 'testKey', (data) =>
                  @data = data
            waitsFor ->
              @data isnt undefined
            , 'No response', 1000
            runs =>
              expect(@data).toBe 'testData'
        describe 'remove', ->
          it "should retrun false for no key", ->
            runs =>
                store.remove 'asd', (success) =>
                  @success = success
              waitsFor ->
                @success isnt undefined
              , 'No response', 1000
              runs =>
                expect(@success).toBe false
          it "should remove item", ->
            runs =>
              store.remove 'testKey', (success) =>
                @success = success
            waitsFor ->
              @success isnt undefined
            , 'No response', 1000
            runs =>
              expect(@success).toBe true
        describe 'set', ->
          it "#{adapter}: should set item", ->
            runs =>
              store.set 'testKey', 'testData', (success) =>
                @success = success
                store.get 'testKey', (data) =>
                  @data = data
            waitsFor ->
              @success isnt undefined && @data isnt undefined
            , 'No response', 1000
            runs =>
              expect(@success).toBe true
              expect(@data).toBe 'testData'
        describe 'list', ->
          it "should list items", ->
            runs =>
              store.list (data) =>
                @data = data
            waitsFor ->
              @data isnt undefined
            , 'No response', 1000
            runs =>
              expect(@data.indexOf('testKey')).toBe 0
          it "should return empty array from list", ->
            runs =>
              store.remove('testKey').list (data) =>
                @data = data
            waitsFor ->
              @data isnt undefined
            , 'No response', 1000
            runs =>
              expect(@data.length).toBe 0
        it "should handle chaining", ->
          runs =>
            store.set('testKey', 'testData').get('testKey').set('testKey','hello there matey').get('testKey').remove 'testKey', (success) =>
              @success = success
          waitsFor ->
            @success isnt undefined
          , 'No response', 1000
          runs =>
            expect(@success).toBe true