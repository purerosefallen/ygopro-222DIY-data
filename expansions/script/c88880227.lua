--Mecha Blade Sky Base
local m=88880227
local cm=_G["c"..m]
function cm.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xffd))
    e2:SetValue(200)
    c:RegisterEffect(e2) 
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(m,0))
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCountLimit(1)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetTarget(cm.target)
    e4:SetCost(cm.cost)
    e4:SetOperation(cm.operation)
    c:RegisterEffect(e4)
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(m,1))
    e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_GRAVE)
    e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e6:SetCost(aux.bfgcost)
    e6:SetCountLimit(1,m)
    e6:SetTarget(cm.target2)
    e6:SetOperation(cm.activate)
    c:RegisterEffect(e6)
end
function cm.thfilter1(c)
    return c:IsSetCard(0xffd) and not c:IsType(TYPE_MONSTER+TYPE_FIELD) and c:IsAbleToHand()
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter1,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.SelectMatchingCard(tp,cm.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function cm.filter(c)
    return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function cm.filter3(c)
    return c:IsSetCard(0xffd) and c:IsType(TYPE_MONSTER)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil)
        and Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_DECK,0,1,nil,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEATTACHFROM)
    local sg=Duel.SelectMatchingCard(tp,Card.CheckRemoveOverlayCard,tp,LOCATION_MZONE,0,1,1,nil,tp,1,REASON_COST)
    sg:GetFirst():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
        local g=Duel.SelectMatchingCard(tp,cm.filter3,tp,LOCATION_DECK,0,1,1,nil,nil)
        if g:GetCount()>0 then end
            Duel.Overlay(tc,g)
        end
