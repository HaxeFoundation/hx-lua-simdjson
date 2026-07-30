package hxluasimdjson;

#if lua
/**
	Extern binding to the native `hxsimdjson` Lua module (installed via
	luarocks from this project's rockspec). Parses a JSON string with
	[simdjson](https://simdjson.org).

	You normally do not call this directly. Adding `-lib hx-lua-simdjson`
	redirects `haxe.Json.parse` / `haxe.format.JsonParser.parse` here via a
	build macro (see `hxluasimdjson.Macro`), so existing `haxe.Json` code
	transparently uses simdjson on the Lua target.
**/
@:luaRequire("hxsimdjson")
extern class Json {
	public static function parse(str:String):Dynamic;
}
#end
