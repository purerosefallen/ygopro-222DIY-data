--Mecha Blade Recruiter
local m=88880210
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddXyzProcedure(c,cm.mfilter,4,2,cm.ovfilter,aux.Stringid(m,0),2,cm.xyzop)
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCountLimit(1,m)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCost(cm.cost)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.operation)
    c:RegisterEffect(e1)
end

function c88880210.mfilter(c)
    return c:IsSetCard(0xffd)
end
function c88880210.ovfilter(c)
    return c:IsFaceup()
        and ((c:IsType(TYPE_XYZ) and c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,88880005))
        or (c:IsCode(88880006) and c:GetOverlayGroup():GetCount()>0))
end
function c88880210.xyzop(e,tp,chk,mc)
    if chk==0 then return mc:CheckRemoveOverlayCard(tp,1,REASON_COST) end
    mc:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) 
        and Duel.CheckLPCost(tp,1000) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
    Duel.PayLPCost(tp,1000)
end
    function cm.filter(c)
    return c:IsSetCard(0xffd) and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter),tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
        Duel.ShuffleDeck(tp)
    end
end