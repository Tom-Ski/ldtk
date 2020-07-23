package led.def;

class EnumDef {
	public var uid(default,null) : Int;
	public var identifier(default,set) : String;
	public var values : Array<{ id:String }> = [];
	public var iconTilesetUid : Null<Int>;

	public function new(uid:Int, id:String) {
		this.uid = uid;
		this.identifier = id;
	}

	function set_identifier(v:String) {
		v = Project.cleanupIdentifier(v,true);
		if( v==null )
			return identifier;
		else
			return identifier = v;
	}

	@:keep public function toString() {
		return '$identifier(' + values.join(",")+")";
	}

	public static function fromJson(dataVersion:Int, json:Dynamic) {
		var ed = new EnumDef(JsonTools.readInt(json.uid), json.identifier);

		for(v in JsonTools.readArray(json.values)) {
			ed.values.push({
				id: v.id,
			});
		}

		ed.iconTilesetUid = JsonTools.readNullableInt(json.iconTilesetUid);

		return ed;
	}

	public function toJson() {
		return {
			identifier: identifier,
			uid: uid,
			values: values.copy(),
			iconTilesetUid: iconTilesetUid,
		};
	}

	public function hasValue(v:String) {
		v = Project.cleanupIdentifier(v,true);
		for(ev in values)
			if( ev.id==v )
				return true;

		return false;
	}

	public inline function isValueIdentifierValidAndUnique(v:String) {
		return Project.isValidIdentifier(v) && !hasValue(v);
	}

	public function addValue(v:String) {
		if( !isValueIdentifierValidAndUnique(v) )
			return false;

		v = Project.cleanupIdentifier(v,true);
		values.push({ id:v });
		return true;
	}

	public function renameValue(from:String, to:String) {
		to = Project.cleanupIdentifier(to,true);
		if( to==null || !isValueIdentifierValidAndUnique(to) )
			return false;

		for(i in 0...values.length)
			if( values[i].id==from ) {
				values[i].id = to;
				return true;
			}

		return false;
	}

	public function tidy(p:Project) {
		// Lost tileset
		if( iconTilesetUid!=null && p.defs.getTilesetDef(iconTilesetUid)==null )
			iconTilesetUid = null;
	}
}
