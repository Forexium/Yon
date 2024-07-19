-- >> Script Key >>
getgenv().script_key = getgenv()['script_key']
-- >> Games >>
local GamesTable = {
	[3150475059] = "https://api.luarmor.net/files/v3/loaders/f04b37a220b0a222f9d6ac27395e4a05.lua"
}
-- >> Variables >>
local Link = GamesTable[game.GameId]
-- >> Checks >>
if not Link then
    print("Invalid.")
end
-- >> Loadstring >>
loadstring(game:HttpGet(Link))()
