package hxluasimdjson;

#if macro
import haxe.macro.Context;
import haxe.macro.Compiler;
import haxe.macro.Expr.Field;

/**
	Redirects the standard JSON parser to the native simdjson binding on the
	Lua target, without shadowing any std file.

	`use()` is invoked automatically as an init macro (see `extraParams.hxml`)
	when this library is added with `-lib hx-lua-simdjson`. It attaches a build
	macro to `haxe.format.JsonParser` which rewrites `parse` to call
	`hxluasimdjson.Json.parse`. On every other target it is a no-op.
**/
class Macro {
	/** Init-macro entry point (called from extraParams.hxml). **/
	public static function use():Void {
		if (Context.defined("lua")) {
			Compiler.addGlobalMetadata("haxe.format.JsonParser", "@:build(hxluasimdjson.Macro.patch())", false);
		}
	}

	/** Build macro: replace the body of `parse` with the simdjson call. **/
	public static function patch():Array<Field> {
		var fields = Context.getBuildFields();
		// The @:build metadata is attached globally, so this also fires when
		// haxe.format.JsonParser is built for the macro/eval context, where the
		// Lua-only extern does not exist. Only redirect for the real Lua target.
		if (!Context.defined("lua")) return fields;
		for (f in fields) {
			if (f.name == "parse") {
				switch (f.kind) {
					case FFun(fn):
						fn.expr = macro return hxluasimdjson.Json.parse(str);
					default:
				}
			}
		}
		return fields;
	}
}
#end
