/*
Author: 
	浮生歇尽
Description: 
	Returns a random enemy vehicle target near the specified unit's facing direction. By default, vehicles that have been set as captives and empty vehicles are not considered.

Syntax: [unit, radius, type, enemyOnly] call JLS_fnc_nearVehicleTarget;

Parameters: 
	0.Unit (optional)		: Object - The unit to be used as the perspective and center for considering vehicles within range.
	1.radius (optional)		: Number - The scanning distance, default is 1500 meters.
	2.Type (optional)		: String or string array - The types to search for, should use main categories like "Air", ["ship","air"], "LandVehicle", etc. Excessive subtypes may reduce retrieval speed. See isKindOf. Default: "LandVehicle".
	3.enemyOnly (optional)	: Boolean - Whether to consider only hostile vehicles. 1. true includes only hostile vehicles. 2. false will include all vehicles.
Return Value: 
	Object - Expected type of vehicle, if there is no match, return Objnull
	
说明：
	返回一个指定单位面朝方向附近的随机敌方载具目标。默认情况下，不考虑设置了俘虏的载具和空的载具。
句法:
	[单位, 半径, 类型, 仅敌对] call JLS_fnc_nearVehicleTarget;
参数:
	0.单位(可选)	: 对象 - 以谁为视角和中心考虑范围内的载具
	1.半径(可选)	: 数字 - 扫描距离，默认1500米;
	2.类型(可选)	: 字符串或字符串数组 - 要搜索的类型，应该使用主类别例如"Air"、["ship","air"]、"LandVehicle"等。过多的子类型会降低检索速度。请参阅nearEntities。默认:"LandVehicle".
	3.敌对(可选)	: 布尔值- 是否敌对，1.true 只包括敌对载具. 2.false 将包括所有载具
返回值:
	物体 - 预期类型的载具，如果没有匹配，返回ObjNull

examples (示例):
	[] call JLS_fnc_nearVehicleTarget; 

	// 寻找500米范围的任何陆地载具 Finds any land vehicle within 500 meters
	[nil, 500 ,"landVehicle", false] call JLS_fnc_nearVehicleTarget; 

	// 通过事件处理程序为发射的导弹设置目标 Set target for fired missiles through event handler
	vehicle player addEventHandler ["Fired", 
	{
		params ["_unit","","","","","","_projectile"];
		_target = [_unit, 1000, "air"] call JLS_fnc_nearVehicleTarget;
		_projectile setMissileTarget _target;
	}]; 
*/

params 
[
	["_source", objNull, [objNull]],
	["_distance", 1500 ,[0]],
	["_type", "LandVehicle" , ["",[]]],
	["_enemyOnly", true, [true]]
];

if (isNull _source) then {_source = player};

// --查找周围实体
private _vehicles = _source nearEntities [_type, _distance];

// --是否过滤非敌对
if (_enemyOnly) then 
{
	_side = side group _source;
	_vehicles = _vehicles select {(_side getFriend side _x) < 0.6};
};

// --获取玩家视野附近的载具
private _dir = getDir _source;
private _targets = _vehicles select {(abs(_dir - (_source getDir _x))) < 45};

// 返回
private _missileTarget = selectRandom _targets;
[_missileTarget, objNull] select (isNil "_missileTarget");