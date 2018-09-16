baka=baka or {}
local cm=baka
baka.loaded_metatable_list={}
function baka.load_metatable(code)
    local m1=_G["c"..code]
    if m1 then return m1 end
    local m2=baka.loaded_metatable_list[code]
    if m2 then return m2 end
    _G["c"..code]={}
    if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
        local mt=_G["c"..code]
        _G["c"..code]=nil
        if mt then
            baka.loaded_metatable_list[code]=mt
            return mt
        end
    else
        _G["c"..code]=nil
    end
end
function baka.check_set(c,setcode,v,f,...) 
    local codet=nil
    if type(c)=="number" then
        codet={c}
    elseif type(c)=="table" then
        codet=c
    elseif type(c)=="userdata" then
        local f=f or Card.GetCode
        codet={f(c)}
    end
    local ncodet={...}
    for i,code in pairs(codet) do
        for i,ncode in pairs(ncodet) do
            if code==ncode then return true end
        end
        local mt=baka.load_metatable(code)
        if mt and mt["named_with_"..setcode] and (not v or mt["named_with_"..setcode]==v) then return true end
    end
    return false
end
function baka.check_set_FragileArticles(c)
    return baka.check_set(c,"FragileArticles")
end
function baka.check_set_FragileLyric(c)
    return baka.check_set(c,"FragileLyric")
end
function baka.check_set_AzayakaSin(c)
    return baka.check_set(c,"AzakayaSin")
end
function baka.check_set_MechanicalCrafter(c)
    return baka.check_set(c,"MechanicalCrafter")
end
function baka.check_set_ApocryphaSaver(c)
    return baka.check_set(c,"ApocryphaSaver")
end