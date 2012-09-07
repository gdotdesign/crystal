describe 'Path', ->
  describe 'create', ->
    it 'should create a single property', ->
      a = {}
      p = new Crystal.Utils.Path(a)
      p.create 'property', 'value'
      expect(a.property).toBe 'value'
    it 'should create deep property', ->
      a = {}
      p = new Crystal.Utils.Path(a)
      p.create 'obj.property', 'value'
      expect(a.obj instanceof Object).toBe true
      expect(a.obj.property).toBe 'value'
    it 'should create really deep property', ->
      a = {}
      p = new Crystal.Utils.Path(a)
      p.create 'b.c.d.e.f', 'value'
      expect(a.b.c.d.e.f).toBe 'value'

  a = 
    property: 'value'
    a:
      property: 'value'
    b:
     c:
      d:
       e:
        f: 'value'
  p = new Crystal.Utils.Path a
  
  describe 'exists', ->
    it 'should retrun true for a single property', ->
      expect(p.exists('property')).toBe true
    it 'should retrun true for deep property', ->
      expect(p.exists('a.property')).toBe true
    it 'should retrun true for really deep property', ->
      expect(p.exists('b.c.d.e.f')).toBe true
    it 'should return false for non existsing property', ->
      expect(p.exists('x')).toBe false
    it 'should return false for non existsing deep property', ->
      expect(p.exists('x.y')).toBe false
    it 'should return false for non existsing really deep property', ->
      expect(p.exists('x.y.z.w.v')).toBe false

  describe 'lookup', ->
    it 'should lookup a single property', ->
      expect(p.lookup('property')).toBe 'value'
    it 'should lookup deep property', ->
      expect(p.lookup('a.property')).toBe 'value'
    it 'should lookup really deep property', ->
      expect(p.lookup('b.c.d.e.f')).toBe 'value'
    it 'should return undefined for non existsing property', ->
      expect(p.lookup('x')).toBe undefined
    it 'should return undefined for non existsing deep property', ->
      expect(p.lookup('x.y')).toBe undefined
    it 'should return undefined for non existsing really deep property', ->
      expect(p.lookup('x.y.z.w.v')).toBe undefined