#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdkhooks>
#include <multicolors>

#define PREFIX "{green}[HostageInfo]{white}"

public Plugin myinfo =
{
	name = "Hostage Event",
	author = "kaye, Nagahi",
	description = "Follow all events for Hostage",
	version = "1.1.2",
	url = ""
};

public void OnPluginStart()
{
	LoadTranslations("HostageEvent.phrases");
	
	HookEvent("hostage_follows", EventHostages, EventHookMode_Post);
	HookEvent("hostage_rescued", EventHostages, EventHookMode_Post);
	HookEvent("hostage_stops_following", EventHostages, EventHookMode_Post);
	HookEvent("hostage_rescued_all", EventHostages, EventHookMode_Post);
}

public void EventHostages(Event event, const char[] name, bool dontBroadcast)
{
	int client = getEventClient(event);
	if (!isValidClient(client)) return;
	
	char Name[32];
	GetClientName(client, Name, sizeof(Name));
	
	if (StrEqual(name, "hostage_follows", false))
	{
		CPrintToChatAll("%s %t", PREFIX, "follows", Name);	
	}
	else if (StrEqual(name, "hostage_rescued", false))
	{
		CPrintToChatAll("%s %t", PREFIX, "rescued", Name);
	}
	else if (StrEqual(name, "hostage_stops_following", false))
	{
		CPrintToChatAll("%s %t", PREFIX, "stops_following", Name);	
	
	else if (StrEqual(name, "hostage_rescued_all", false))
	{
		CPrintToChatAll("%s %t", PREFIX, "rescued_all", Name);
	}
}

static int getEventClient(Event event)
{
	return GetClientOfUserId(event.GetInt("userid"));
}

static bool isClient(int index)
{
	if (index > 4096)
	{
		index = EntRefToEntIndex(index);
	}
	
	return ((index > 0) && (index <= MaxClients));
}

static bool isValidClient(int client)
{
	if (!isClient(client)) return false;
	if (!IsClientConnected(client)) return false;
	if (!IsClientInGame(client)) return false;
	if (IsClientInKickQueue(client)) return false;
	
	return true;
}