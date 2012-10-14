UNICODE_CHARS = "\u043F\u0440\u0438\u0432\u0435\u0442 \u043C\u0438\u0440"
DECODE_TESTS = [
	["aGVsbG8gd29ybGQ=", "hello world", "ASCII"]
	["aGVsbG8gd29ybGQ=\n", "hello world", "ASCII with trailing newline"]
	["  aGVsbG8gd29ybGQ= ", "hello world", "ASCII unstripped"]
	["0L/RgNC40LLQtdGCINC80LjRgA==", UNICODE_CHARS, "Unicode"]
	["0L/RgNC40LLQtdGCINC80LjRgA==\n", UNICODE_CHARS, "Unicode with trailing newline"]
	["  0L/RgNC40LLQtdGCINC80LjRgA==   ", UNICODE_CHARS, "Unicode unstripped"]
]
ENCODE_TESTS = [
	["hello world", "aGVsbG8gd29ybGQ=", "ASCII"]
	[UNICODE_CHARS, "0L/RgNC40LLQtdGCINC80LjRgA==", "Unicode"]
]

describe "Base64", ->
	describe "decode", ->
		DECODE_TESTS.forEach (test) ->
			it "should decode #{test[2]}", ->
				expect(Base64.decode(test[0])).toBe test[1]
	describe "encode", ->
		ENCODE_TESTS.forEach (test) ->
			it "should encode #{test[2]}", ->
				expect(Base64.encode(test[0])).toBe test[1]

