local lplr = game:GetService("Players").LocalPlayer; -- cloneref doesnt work i tried it with httpservice
local skidstore: table = {
    skidver = 'Next-Gen';
    skiduser = lplr.Name;
    skiduserid = lplr.UserId;
    AntiLog = function()
        local request = http_request or request or HttpPost or syn.request or fluxus.request;
        local oldfunc;
        oldfunc = hookfunction(request, function(requestData,...)
            if string.find(requestData.Url, 'discord' or 'webhook' or 'ipv4' or 'paypal' or 'roblox' or 'voidware' or 'grabify' or 'iplogger') then
                requestData.Url = nil;
            end;
        end);
        return oldfunc;
    end;
}

return skidstore;
