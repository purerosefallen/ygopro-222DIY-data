--踏无暴威
local m=60159927
local cm=_G["c"..m]
function cm.initial_effect(c)
    --
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCountLimit(1,60159927+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(c60159927.drcon1)
    e1:SetOperation(c60159927.drop1)
    c:RegisterEffect(e1)
end
function c60159927.filter(c,sp)
    return c:GetSummonPlayer()==tp and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c60159927.drcon1(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c60159927.filter,1,nil,1-tp) 
end
function c60159927.drop1(e,tp,eg,ep,ev,re,r,rp)
    local damp=eg:GetFirst():GetPreviousControler()
    Duel.SetLP(damp,Duel.GetLP(damp)/2)
end