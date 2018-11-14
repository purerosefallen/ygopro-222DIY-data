--卡斯L&卡斯R
local m=47530008
local cm=_G["c"..m]
function c47530008.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_MACHINE),2,99,c47530008.lcheck)
    c:EnableReviveLimit() 
    --disable
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(0,LOCATION_MZONE)
    e2:SetTarget(c47530008.disable)
    e2:SetCode(EFFECT_DISABLE)
    c:RegisterEffect(e2) 
    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47530008,0))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(c47530008.target)
    e3:SetOperation(c47530008.operation)
    c:RegisterEffect(e3)
end
function c47530008.filter(c,e,tp)
    return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,c:GetLink(),nil)
end
function c47530008.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c47530008.filter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c47530008.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c47530008.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,g:GetFirst():GetLink(),tp,LOCATION_HAND)
end
function c47530008.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
       Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
       local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,tc:GetLink(),tc:GetLink(),nil)
       if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)~=0 then
          Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
       end
    end
end
function c47530008.disable(e,c)
    local seq=aux.MZoneSequence(c:GetSequence())
    return Duel.IsExistingMatchingCard(c47530008.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,seq)
end
function c47530008.cfilter(c,seq2)
    local seq1=aux.MZoneSequence(c:GetSequence())
    return c:IsFaceup() and c:IsRace(RACE_MACHINE) and seq1==4-seq2 and c:GetSummonLocation()==LOCATION_EXTRA
end
function c47530008.lcheck(g,lc)
    return g:GetClassCount(Card.GetCode)==g:GetCount()
end