--Mecha Blade's Electric Overcharge
local m=88880230
local cm=_G["c"..m]
function cm.initial_effect(c)
       --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,0x1c0)
    e1:SetCountLimit(1,88880030)
    e1:SetCondition(cm.handcon)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
    --act in hand
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e2:SetCondition(cm.handcon)
    c:RegisterEffect(e2) 
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetRange(LOCATION_GRAVE)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetHintTiming(0,TIMING_END_PHASE)
    e4:SetCondition(cm.gycon)
    e4:SetCost(aux.bfgcost)
    e4:SetCountLimit(1,88880130)
    e4:SetTarget(cm.target2)
    e4:SetOperation(cm.activate2)
    c:RegisterEffect(e4)
end
function cm.handcon(e)
    return Duel.GetCurrentChain()>=2 or Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.gycon(e)
    return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.cfilter(c)
    return c:IsSetCard(0xffd)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local g1=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
    local g=g1:Select(tp,1,1,nil)
    Duel.SendtoHand(g,nil,REASON_EFFECT)
end
function cm.filter(c)
    return not c:IsCode(m) and (c:IsLocation(LOCATION_HAND+LOCATION_GRAVE) or c:IsFaceup()) and c:IsAbleToDeck()
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_REMOVED,0,nil)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
        and g:GetClassCount(Card.GetCode)>=3 end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.filter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_REMOVED,0,nil)
    if g:GetClassCount(Card.GetCode)<3 then return end
    local sg=Group.CreateGroup()
    for i=1,3 do
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local g1=g:Select(tp,1,1,nil)
        g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
        sg:Merge(g1)
    end
    local cg=sg:Filter(Card.IsLocation,nil,LOCATION_HAND)
    if cg:GetCount()>0 then
        Duel.ConfirmCards(1-tp,cg)
    end
    Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
    local og=Duel.GetOperatedGroup()
    if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
    local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
    if ct==3 then
        Duel.BreakEffect()
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end
