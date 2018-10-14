--的场梨沙
function c81012017.initial_effect(c)
    --search
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(81012017,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,81012017)
    e1:SetCost(c81012017.thcost)
    e1:SetTarget(c81012017.thtg)
    e1:SetOperation(c81012017.thop)
    c:RegisterEffect(e1) 
end
function c81012017.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDiscardable() end
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c81012017.thfilter1(c)
    return c:IsCode(81012017) and c:IsAbleToHand()
end
function c81012017.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(c81012017.thfilter1,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c81012017.thop(e,tp,eg,ep,ev,re,r,rp,chk)
    local tg=Duel.GetFirstMatchingCard(c81012017.thfilter1,tp,LOCATION_DECK,0,nil)
    if tg then
        Duel.SendtoHand(tg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tg)
    end
end

