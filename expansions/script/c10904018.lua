--群集的灵刻使
local m=10904018
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,0x1e0)
    e1:SetTarget(cm.tgtg)
    e1:SetOperation(cm.tgop)
    c:RegisterEffect(e1)    
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,1))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e3:SetCountLimit(1,m)
    e3:SetCondition(cm.scon)
    e3:SetCost(aux.bfgcost)
    e3:SetTarget(cm.sptg)
    e3:SetOperation(cm.spop)
    c:RegisterEffect(e3) 
end
function cm.cfilter(c,type)
    return c:IsFaceup() and c:IsSetCard(0x237) and c:IsType(type)
end
function cm.cfilter2(c)
    return c:IsFaceup() and c:IsCode(10904017)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE+LOCATION_HAND)>0 and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil,TYPE_FUSION)
        and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil,TYPE_SYNCHRO)
        and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil,TYPE_XYZ)
        and (Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil,TYPE_LINK) or Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_SZONE,0,1,nil)) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_SZONE+LOCATION_HAND)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_SZONE+LOCATION_HAND,0,nil,TYPE_SPELL+TYPE_TRAP)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
        local sg=g:Select(1-tp,2,2,nil)
        Duel.HintSelection(sg)
        Duel.Remove(sg,POS_FACEDOWN,REASON_RULE)
    end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        c:CancelToGrave()
        Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
    end
end
function cm.scon(e,tp,eg,ep,ev,re,r,rp)
    local tp=e:GetHandler():GetControler()
    local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
    local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
    if not tc1 or not tc2 then return false end
    return tc1:GetLeftScale()==tc2:GetRightScale()
end
function cm.filter(c,e,tp,ft)
    return c:IsSetCard(0x237) and c:IsFaceup() and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp,ft) end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp,ft)
    local tc=g:GetFirst()
    if tc then
        if ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
            and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(28201945,1))) then
            Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
        else
            Duel.SendtoHand(tc,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,tc)
        end
    end
end
