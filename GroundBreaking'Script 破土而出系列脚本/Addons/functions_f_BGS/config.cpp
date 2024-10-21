
class CfgPatches 
{
	class A3_Funtions_F_JLS
	{
		author = "$STR_BGS_description_Producer2_1";
		name = "$STR_BGS_description_name";
		requiredAddons[] = {"A3_Functions_F"};
		requiredVersion = 0.1;
		units[] = {};
		weapons[] = {};
	};
};


class CfgFunctions 
{
	class JLS
	{
		class GroundBreaking 
		{
			file = "functions_f_BGS\functions";
			class missileComing		{};
			class missileRain		{};
			class nearEnemyVehicle	{};
			class nearVehicleTarget	{};
		};
	};
};