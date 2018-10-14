--八神牧野
function c81012023.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(81012023,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,81012023)
    e1:SetCondition(c81012023.spcon)
    c:RegisterEffect(e1)
end
function c81012023.filter(c,tp,race)
    if c:IsFacedown() then return false end
    if not race then
        return Duel.IsExistingMatchingCard(c81012023.filter,tp,LOCATION_MZONE,0,1,c,tp,c:GetRace())
    else
        return c:IsRace(race)
    end
end
function c81012023.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c81012023.filter,c:GetControler(),LOCATION_MZONE,0,1,nil,c:GetControler())
end
