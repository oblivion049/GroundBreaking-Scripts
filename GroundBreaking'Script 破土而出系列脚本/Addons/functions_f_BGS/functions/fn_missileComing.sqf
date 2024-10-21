/*
	Author: 
		浮生歇尽Pro_Max
	Description:
		Series of settings: Leviathan mecha launches missiles into the sky, generating a lot of smoke near it and under the players' feet, followed by the same number of missile attacks.
	Syntax:
		[Source, Radius, Number, Ammo, Target, Time, Bool] spawn JLS_fnc_missileComing;
	Parameters:
		0. Source: object - the center of the attack range;
		1. Radius 	(optional): radius - range of missile generation, default 200 (no missile will be generated at 40 meters near Leviathan, maximum range=40+200);
		2. Number	(optional): Number - Number of missiles generated, default: 3-6;
		3. Ammo 	(optional): Character - Type of bullet generated, default: "Rocket_04_AP_F";
		4. Target 	(optional): Object or array - main attack object, default: all players;
		5. Time 	(optional): Number - The duration of the digital smoke warning, and the missile will arrive after it stops generating (not disappearing);
		6. Text 	(optional): Boolean - Whether to display warning messages on the screen, default to true.
	Return: 
		Nothing
	
	说明：
		破土而出系列设定：利维坦机甲朝天空发射导弹，在其附近和玩家脚下生成大量烟雾，随之而来的是相同数量的导弹袭击。
	句法:
		[源, 半径, 数量, 弹药, 目标, 时间, 文字] spawn JLS_fnc_missileComing;
		0.发射源		: 物体	- 攻击范围的中心;
		1.半径(可选)	: 半径	- 生成导弹的范围，默认200(利维坦附近40米不会生成导弹,最大范围 = 40 + 200);
		2.数量(可选)	: 数字	- 生成的导弹数量，默认: 3~6 ;
		3.弹药(可选)	: 字符	- 生成的子弹类型，默认: "Rocket_04_AP_F";
		4.目标(可选)	: 对象或数组	- 主要的攻击对象，默认:所有玩家;
		5.时间(可选)	: 数字	- 烟雾预警的持续时间，导弹会在其停止生成后(不是消失)到来;
		6.文字(可选)	: 布尔	- 是否显示屏幕上的警告信息，默认true。
	返回:
		Nothing

	examples (示例) :
		1.	[BIS_Tank, 100, 16 + random 8, "Sh_120mm_HEAT_MP_T_Red", nil, 5, true] spawn JLS_fnc_missileComing;
		2.	[BIS_source, nil, nil, nil, units BIS_playergroup, nil, false] spawn JLS_fnc_missileComing;
		3.	[player, nil, nil, nil, units BIS_EnemyGroup] spawn JLS_fnc_missileComing; //通过玩家发射，攻击BIS_EnemyGroup成员

*/

params
[
	["_source", objNull, [objNull]],
	["_radius", 240, [0]],
	["_rounds", (5 + random 5), [0]],
	["_class", "Rocket_04_AP_F", [""]],
	["_targets", [], [[],objNull]],
	["_time", 6, [0], 1],
	["_showtext", true, [true]]
];

// 必须存在发射源
if (_source isEqualTo objNull) exitWith {};
systemChat str [count _targets, _targets];
// 如果没有定义攻击目标，则选择所有玩家
if (_targets isEqualTo []) then 
{
	_targets = allPlayers select {_x distance _source <= _radius};
};
if (_targets isEqualType objNull) then {_targets = [_targets]};

// 定义需要攻击的坐标
private _attackPos = [];
{
	_attackPos pushBack (getposATL _x);
} forEach _targets;

// 定义额外的空袭坐标
for "_i" from 0 to _rounds do 
{
	_attackPos pushBack (_source getpos [40 + random _radius, random 360]);
};

{
	// 泰坦向空中发射导弹
	private _missileFake = createVehicle [_class, _source modelToWorld [-2 + random 4,-6 + random 2, 6 + random 2]];
	_missileFake  setVectorDirAndUp  [[0, 0, 1], [0,-1, 0]];
	_missileFake setVelocity [0,0,500];

	[_x, _time, _class, _missileFake] spawn 
	{
		params ["_pos", "_time", "_class", "_missileFake"];

		sleep 3;
		deleteVehicle _missileFake;
		// 坐标烟雾预警
		private _smoke = createVehicle ["SmokeShellOrange", _pos];
		sleep _time;
		deletevehicle _smoke;
		sleep (4 + random 2);

		// 导弹来袭
		_pos set [2, 500];
		_MissileIn = _class createVehicle _pos;
		_MissileIn setVectorDirAndUp [[0, 0, -1], [0, 1, 0]];
		_MissileIn setVelocity [0, 0, -300];	
	};
	sleep (0.1 + random 0.2);
} forEach _attackPos;

// 提示警告信息
if (_showtext) then 
{
	[  
		[  
			["Warning !","", "#CC0000"],
			["","<br/>"],
			["The missile is coming !", "", "#CC0000"]
		],
		safeZoneX - 0.01, safeZoneH * 0.1,
		true,
		"<t font='PuristaSemibold' align = 'center' size = '1.2'>%1</t>"
	] remoteExec ["BIS_fnc_typeText2"];
};

// 生成空袭
// {[_x, _Missile, _time] spawn _fn_Missilecoming} forEach _attackPos;



