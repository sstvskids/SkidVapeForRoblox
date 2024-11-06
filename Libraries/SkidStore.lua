local lplr = cloneref(game:GetService("Players")).LocalPlayer;
local skidstore : table = {
    skidver = 'Next-Gen';
    skiduser = lplr.Name;
    skiduserid = lplr.UserId;
    AntiLog = function()
        local request = http_request or request or HttpPost or syn.request or fluxus.request;
        local blockedrequests : table = {'discord', 'webhook', 'ipv4', 'ipv6', 'paypal', 'roblox', 'voidware'};
        local oldfunc;
        oldfunc = hookfunction(request, function(requestData,...)
            for i,v in pairs(blockedrequests) do
                if string.find(requestData.Url, v) then
                    requestData.Url = nil;
                end;
            end;
        end);
        return oldfunc;
    end;
};

return skidstore;