getgenv().script_key = getgenv()['script_key']

local GamesTable = {
    [3150475059] = "https://api.luarmor.net/files/v3/loaders/749ad0388df8fd981d979d9dbefda694.lua",
    [1008451066] = "https://api.luarmor.net/files/v3/loaders/7d0911cf869a1a320d7cdfead79aa59c.lua"
}

local Link = GamesTable[game.GameId]

if not Link then
    print("Invalid.")
end

loadstring(game:HttpGet(Link))()
