--机械降神
local m=62200033
local cm=_G["c"..m]
function cm.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(cm.tg)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
end
function cm.tgfilter(c,e,tp,type)
    return c:IsType(type) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and Duel.IsExistingMatchingCard(cm.tgfilter1,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA,0,1,c,e,tp,type-bit.band(type,c:GetType()),c) and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.tgfilter1(c,e,tp,type,mc)
    local mg=Group.FromCards(c,mc)
    return c:IsType(type) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and Duel.IsExistingMatchingCard(cm.tgfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA,0,1,mg,e,tp,type-bit.band(type,c:GetType()),mg)
end
function cm.tgfilter2(c,e,tp,type,mg)
    mg:AddCard(c)
    return c:IsType(type) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,mg,e,tp)
end
function cm.spfilter(c,e,tp)
    return c:IsCode(62200040) and c:IsCanBeSpecialSummoned(e,0,tp,false,true)
end
function cm.matfilter(c,e,type)
    return c:IsType(type) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    local type=TYPE_NORMAL+TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK
    if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA,0,1,nil,e,tp,type) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()==0 then return end
    local tc=g:GetFirst()
    local type=TYPE_NORMAL+TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        loc=LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA
    else
        loc=LOCATION_ONFIELD
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g1=Duel.SelectMatchingCard(tp,cm.matfilter,tp,loc,0,1,1,tc,e,type)
    if bit.band(type,g1:GetFirst():GetType())~=0 then
        type=type-bit.band(type,g1:GetFirst():GetType())
    end
    g1:AddCard(tc)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g2=Duel.SelectMatchingCard(tp,cm.matfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA,0,1,1,g1,e,type)
    if bit.band(type,g2:GetFirst():GetType())~=0 then
        type=type-bit.band(type,g2:GetFirst():GetType())
    end
    g1:Merge(g2)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g3=Duel.SelectMatchingCard(tp,cm.matfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA,0,1,1,g1,e,type)
    g1:Merge(g3)
    g1:RemoveCard(tc)
    if Duel.SendtoGrave(g1,REASON_EFFECT)==0 or not tc then return end
    Duel.BreakEffect()
    Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
    tc:CompleteProcedure()
end