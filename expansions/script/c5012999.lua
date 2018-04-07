--赌场
function c5012999.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --draw
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_DRAW)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_FZONE)
    e4:SetProperty(EFFECT_FLAG_BOTH_SIDE)
    e4:SetCountLimit(2)
    e4:SetCost(c5012999.effcost)
    e4:SetTarget(c5012999.drtg)
    e4:SetOperation(c5012999.drop)
    c:RegisterEffect(e4)
end
function c5012999.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil)
    Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c5012999.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c5012999.drop(e,tp,eg,ep,ev,re,r,rp)
    local res=Duel.TossCoin(tp,1)
    if res==1 then 
        if Duel.Draw(tp,1,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(nil,tp,LOCATION_REMOVED,0,1,nil) 
            and Duel.SelectYesNo(tp,aux.Stringid(25012999,0)) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
            local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_REMOVED,0,1,1,nil)
            Duel.SendtoHand(g,nil,REASON_EFFECT+REASON_RETURN)
        end
    end
end