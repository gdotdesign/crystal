describe  'Store', ->
  #['LOCAL_STORAGE','INDEXED_DB','WEB_SQL','XHR','FILE_SYSTEM','MEMORY'].forEach (adapter) ->
  ['LOCAL_STORAGE','WEB_SQL','MEMORY'].forEach (adapter) ->
    describe adapter, ->
      store = new Store adapter: Store[adapter], prefix: adapter
      it "#{adapter}: should retrun false for no key (get)", ->
          runs =>
            store.get 'asd', (success) =>
              @success = success
          waitsFor ->
            @success isnt undefined
          , 'No response', 1000  
          runs =>
            expect(@success).toBe false
      it "#{adapter}: should retrun false for no key (remove)", ->
        runs =>
            store.remove 'asd', (success) =>
              @success = success
          waitsFor ->
            @success isnt undefined
          , 'No response', 1000  
          runs =>
            expect(@success).toBe false
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
      it "#{adapter}: should get item", ->
        runs =>
          store.get 'testKey', (data) =>
            @data = data
        waitsFor ->
          @data isnt undefined
        , 'No response', 1000  
        runs =>
          expect(@data).toBe 'testData'
      it "#{adapter}: should list items", ->
        runs =>
          store.list (data) =>
            @data = data
        waitsFor ->
          @data isnt undefined
        , 'No response', 1000  
        runs =>
          expect(@data.indexOf('testKey')).toBe 0
      it "#{adapter}: should remove item", ->
        runs =>
          store.remove 'testKey', (success) =>
            @success = success
        waitsFor ->
          @success isnt undefined
        , 'No response', 1000  
        runs =>
          expect(@success).toBe true
      it "#{adapter}: should return empty array from list", ->
        runs =>
          store.list (data) =>
            @data = data
        waitsFor ->
          @data isnt undefined
        , 'No response', 1000  
        runs =>
          expect(@data.length).toBe 0
      it "#{adapter}: chain test", ->
        runs =>
          store.set('testKey', 'testData').get('testKey').set('testKey','hello there matey').get('testKey').remove 'testKey', (success) =>
            @success = success
        waitsFor ->
          @success isnt undefined
        , 'No response', 1000  
        runs =>
          expect(@success).toBe true