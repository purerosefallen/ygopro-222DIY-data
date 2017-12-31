--无名的存在
local m=2111002
local cm=_G["c"..m]
function cm.initial_effect(c)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,c2111002.matfilter,1,1)
    --Normal monster
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetCode(EFFECT_ADD_SETCODE)
    e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
    e1:SetValue(0x218)
    c:RegisterEffect(e1)
end
function c2111002.matfilter(c)
    return c:IsSetCard(0x218) and c:IsLevelBelow(3)
end