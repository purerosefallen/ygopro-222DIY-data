--Mecha Blade Repair Shop
local m=88880223
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:SetUniqueOnField(1,0,88880223)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetOperation(c88880223.activate)
    c:RegisterEffect(e1)
    --To Hand
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c88880223.thcon)
    e2:SetTarget(c88880223.thtg)
    e2:SetOperation(c88880223.thop)
    c:RegisterEffect(e2)
end
function c88880223.thfilter(c)
    return c:IsSetCard(0xffd) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c88880223.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(c88880223.thfilter,tp,LOCATION_DECK,0,nil)
    if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(88880223,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=g:Select(tp,1,1,nil)
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
    end
end
function c88880223.thfilter2(c,tp)
    return c:IsSetCard(0xffd) and c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c88880223.thcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c88880223.thfilter2,1,nil,tp)
end
function c88880223.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=eg:Filter(c88880223.thfilter2,nil,tp)
    Duel.SetTargetCard(g)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c88880223.thop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local rg=g:Select(tp,1,1,nil)
    if rg:GetCount()>0 then
        Duel.SendtoHand(rg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,rg)
    end
end