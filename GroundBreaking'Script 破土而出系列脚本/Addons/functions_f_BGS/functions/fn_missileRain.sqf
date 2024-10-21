
/*
Author: 
	浮生歇尽Pro_Max
Description:
	Randomly generate a certain number of missiles in the air near the provided location, and the missiles will fall at a certain speed. Finally, a fixed missile attack center coordinate will be generated.
Syntax:
	[Position, Radius, Number, Ammo, Target] spawn JLS_fnc_MissileRain;
Parameters:
	0. Center : Array - A positional array in [x, y, z] format;
	1. Radius (optional)	: Radius - The range of the generated missile, default to 200;
	2. Number (optional)	: Number - Number of missiles, default to 5-10;
	3. Ammo (optional): String - Ttype of bullet generated, default to "Rocket_04_AP_F";
	4. Target (optional)	: Object or Array - Additional attack objects (even outside the predetermined range), default: Nothing.
Return: 
	Nothing

说明：
	破土而出系列设定“导弹袭击”简化版本：在提供的位置附近空中随机生成一定数量的导弹，导弹以一定速度下落，最后固定生成一枚导弹攻击中心坐标。
句法:
	[中心, 半径, 数量, 弹药, 目标] spawn JLS_fnc_MissileRain;
	0.中心	: 数组	- [x,y,z]格式的位置数组;
	1.半径(可选)	: 半径		- 生成导弹的范围，默认200;
	2.数量(可选)	: 数字		- 导弹数量，默认 5 ~ 10枚;
	3.弹药(可选)	: 字符串	- 生成的子弹类型，默认"Rocket_04_AP_F";
	4.目标(可选)	: 对象或对象数组- 额外攻击对象(甚至可以是预定范围之外的)，默认：没有.
返回:
	Nothing

examples (示例) :
	1.	[[5000, 5000, 0], 300, 10 + random 5, "Sh_155mm_AMOS", units player] spawn JLS_fnc_MissileRain; 
	2.	[getposATL player, 200] spawn JLS_fnc_MissileRain; // Generate 200 meters at the center of the player.	
	3.	[getposATL player] spawn JLS_fnc_MissileRain;

*/

params[
	["_center", [], [[]]],
	["_radius", 200, [0]],
	["_rounds", (6 + random 6), [0]],
	["_class", "Rocket_04_AP_F", [""]],
	["_targets", [], [[],objNull]],
	["_end", true, [true]]
];

if (_center isEqualTo []) exitWith {};

// 初始化空袭
private _missilePos = [];

// 定义随机空袭坐标
for "_i" from 1 to _rounds do 
{
	_missilePos pushBack (_center getpos [random _radius, random 360]);
};

// 定义额外坐标
if (_targets isEqualType []) then 
{
	{_missilePos pushBack (getPosATL _x)} forEach _targets;
}
else
{
	// 存在目标参数，但属于非数组的物体
	_missilePos pushBack (getPosATL _targets);
};

// 生成空袭
{	
	_x set [2,1000];
	_missileIn = createVehicle [_class, _x, [], 0, "CAN_COLLIDE"];
	_missileIn setVectorDirAndUp [[0, 0, -1], [0, 1, 0]];
	_missileIn setVelocity [0,0,-300];
	sleep (0.1 + random 0.1);
} forEach _missilePos;

// 目标中心处的额外打击
if (_end) then 
{
	sleep (0.2 + random 0.3);
	_center set [2, 1000];
	_missileEnd = createVehicle [_class, _center, [], 0, "CAN_COLLIDE"];
	_missileEnd setVectorDirAndUp [[0, 0, -1], [0, 1, 0]];
};

sleep 2.5;
true;

