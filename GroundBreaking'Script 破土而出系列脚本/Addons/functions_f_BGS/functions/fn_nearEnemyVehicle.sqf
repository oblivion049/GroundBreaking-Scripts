/*
Author: 
	浮生歇尽
Description:
	Return to an enemy vehicle target (Excluding vehicles with prisoners and vehicles without members, as well as all ships) near the player's line of sight.
Syntax:
	[ Distance, type, Hostile] call JLS_fnc_NearEnemyVehicle;
Parameters:
	0 (Optional):	Distance - Number. Scan range, default: 2000 metre;
	1 (Optional):	String	 - Target type. List of allowed type ,One of the following:("Air","landVehicle","all").default: "all";
	2 (optional):	Hostile  - Boolean value. Hostile or not: 1. True. only includes hostile vehicles 2. False. include all vehicles
Return: 
	Object - Expected type of vehicle, if there is no match, return Objnull

说明：
	返回一个玩家视线附近的敌方载具目标（不包括设置了俘虏的载具和没有成员的载具，以及所有船只）。
句法:
	[距离, 类型] call JLS_fnc_NearEnemyVehicle;
参数:
	0.距离(可选)	: 数字	- 扫描距离，默认2000米;
	1.类型(可选)	: 字符串- 选择类型，可以是 "Air"、"landVehicle"、"all"。默认:"all";
	2.敌对(可选)	: 布尔值- 是否敌对，1.true 只包括敌对载具. 2.false 将包括所有载具
返回值:
	物体 - 预期类型的载具，如果没有匹配，返回ObjNull

examples (示例):
	[] call  JLS_fnc_NearEnemyVehicle; 

	// 寻找500米范围的任何陆地载具 Finds any land vehicle within 500 meters
	[500 ,"landVehicle", false] call  JLS_fnc_NearEnemyVehicle; 

	// 通过事件处理程序为发射的导弹设置目标 Set target for fired missiles through event handler
	vehicle player addEventHandler ["Fired", 
	{
		params ["","","","","","","_projectile"];
		_target = [1000, "air"] call  JLS_fnc_NearEnemyVehicle;
		_projectile setMissileTarget _target;
	}]; 
*/

params 
[
	["_distance", 1500 ,[0]],
	["_type", "All", [""]],
	["_enemyOnly", true, [true]]
];

private _source = player;
private _vehicles = vehicles select {_x iskindof _type};

if (_enemyOnly) then 
{
	_side = side group _source;
	_vehicles = _vehicles select {(_side getFriend side _x) < 0.6};
};

// 获取玩家视野附近的载具
private _dir = getdir _source;
private _targets = _vehicles select {(_x distance _source <= _distance) && {(abs(_dir - (_source getdir _x))) < 45}};

// 产生最终目标
private _missileTarget =  selectrandom _targets;

[_missileTarget, objNull] select (isNil "_missileTarget");
