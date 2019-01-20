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
--fool
function baka.check_set_FragileArticles(c)
    return baka.check_set(c,"FragileArticles")--玻 离 之 物
end
function baka.check_set_FragileLyric(c)
    return baka.check_set(c,"FragileLyric")--玻 离 乐 章
end
--lover
function baka.check_set_AzayakaSin(c)
    return baka.check_set(c,"AzakayaSin")--华 欲
end
--magician
function baka.check_set_MechanicalCrafter(c)
    return baka.check_set(c,"MechanicalCrafter")--机 匠 工 造
end
--judgement
function baka.check_set_ApocryphaSavior(c)
    return baka.check_set(c,"ApocryphaSavior")--外 典 救 世 主
end
--
function baka.check_set_PregnantSwordHime(c)
    return baka.check_set(c,"PregnantSwordHime")--孕 剑 姬
end
--
function baka.check_set_BugOfBug(c)
    return baka.check_set(c,"BugOfBug")--残 思 乐 源
end
--
function baka.check_set_AnoKare(c)
    return baka.check_set(c,"AnoKare")--残 思 乐 源
end