--伏龙王-冥浊
function c50218555.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,7,2)
    c:EnableReviveLimit()
    --to deck
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(50218555,0))
    e1:SetCategory(CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(c50218555.tdcon)
    e1:SetCost(c50218555.tdcost)
    e1:SetTarget(c50218555.tdtg)
    e1:SetOperation(c50218555.tdop)
    c:RegisterEffect(e1)
    --get effect
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(50218555,1))
    e2:SetCategory(CATEGORY_TODECK)
    e2:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_XMATERIAL)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c50218555.tdcon)
    e2:SetCost(c50218555.tdcost)
    e2:SetTarget(c50218555.tdtg)
    e2:SetOperation(c50218555.tdop)
    c:RegisterEffect(e2)
end
function c50218555.tdcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayGroup():GetClassCount(Card.GetCode)>=2 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c50218555.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c50218555.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c50218555.tdop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    if sg:GetCount()>0 then
        Duel.HintSelection(sg)
        Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
    end
end