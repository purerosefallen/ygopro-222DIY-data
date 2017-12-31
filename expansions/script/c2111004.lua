--纯狐（特别定制版）
local m=2111004
local cm=_G["c"..m]
function cm.initial_effect(c)
    --yyyy
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(2111004,0))
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetTarget(c2111004.tgtg)
    e4:SetOperation(c2111004.tgop)
    c:RegisterEffect(e4) 
end
function c2111004.filter(c)
    return (aux.IsCodeListed(c,2111001) or c:IsCode(2111001)) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c2111004.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c2111004.filter,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c2111004.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c2111004.filter,tp,LOCATION_DECK,0,1,1,nil)
    local tc=g:GetFirst()
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end