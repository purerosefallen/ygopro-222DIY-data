--心之所在
local m=2111003
local cm=_G["c"..m]
function cm.initial_effect(c)
    --Normal monster
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetCode(EFFECT_ADD_SETCODE)
    e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
    e1:SetValue(0x218)
    c:RegisterEffect(e1)
    --yyyy
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(2111003,0))
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetCountLimit(1,2111003)
    e4:SetTarget(c2111003.tgtg)
    e4:SetOperation(c2111003.tgop)
    c:RegisterEffect(e4) 
end
function c2111003.filter(c,ignore)
    return (aux.IsCodeListed(c,2111001) or c:IsCode(2111001)) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(ignore)
end
function c2111003.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c2111003.filter,tp,LOCATION_DECK,0,1,nil,false) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c2111003.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c2111003.filter,tp,LOCATION_DECK,0,1,1,nil,false)
    local tc=g:GetFirst()
    if g:GetCount()>0 then
          Duel.SSet(tp,tc)
          Duel.ConfirmCards(1-tp,tc)
    end
end