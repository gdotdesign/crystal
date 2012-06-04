exports["color test"] = (test) ->
  c = new Color
  c.hex = "000000"
  test.strictEqual c.hex, "000000"
  test.strictEqual c.red, 0
  c.red = 255
  test.strictEqual c.hex, "FF0000"
  test.done()
