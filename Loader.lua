getgenv().script_key = getgenv()['script_key']

local GamesTable = {
    [3150475059] = "https://api.luarmor.net/files/v3/loaders/7ad69f68f33655206b034cb47962c830.lua",
    [2788229376] = "https://api.luarmor.net/files/v3/loaders/23b69dc2d8698beaa88323e1f5d1e4eb.lua",
    [16033173781] = "https://api.luarmor.net/files/v3/loaders/23b69dc2d8698beaa88323e1f5d1e4eb.lua"
}

local Link = GamesTable[game.GameId]

if not Link then
    print("Invalid.")
end

loadstring(game:HttpGet(Link))()
