--宫本芙蕾德莉卡
function c81011004.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,c81011004.mfilter,2)
    c:EnableReviveLimit()
    --cannot attack
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_ATTACK)
    e1:SetCondition(c81011004.atcon)
    c:RegisterEffect(e1)
end
function c81011004.mfilter(c)
    return c:IsLinkRace(RACE_FIEND) and not c:IsLinkType(TYPE_TOKEN)
end
function c81011004.atcon(e)
    return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)>1
end
