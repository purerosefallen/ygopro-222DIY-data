--华欲雏莺 宝石
local m=62200008
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c62200000")end,function() require("script/c62200000") end)
cm.named_with_AzayakaSin=true
function c62200008.initial_effect(c)
    --searchmonster
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(62200008,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1)
    e1:SetCondition(c62200008.con1)
    e1:SetTarget(c62200008.tg1)
    e1:SetOperation(c62200008.op1)
    c:RegisterEffect(e1)
    --searchspta
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(62200008,1))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCondition(c62200008.con2)
    e2:SetTarget(c62200008.tg2)
    e2:SetOperation(c62200008.op2)
    c:RegisterEffect(e2)    
end
--
function c62200008.con1filter(c)
    return c:GetControler()~=c:GetOwner()
end
function c62200008.con1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c62200008.con1filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c62200008.tg1filter(c)
    return baka.check_set_AzayakaSin(c) and c:IsType(TYPE_MONSTER) and not c:IsCode(62200008) and c:IsAbleToHand()
end
function c62200008.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c62200008.tg1filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c62200008.op1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c62200008.tg1filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
        Duel.Draw(1-tp,1,REASON_EFFECT)
    end
end
--
function c62200008.con2(e,tp,eg,ep,ev,re,r,rp,c)
    return e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7f0)
        and re:GetHandler():check_set_AzayakaSin(c)
end
function c62200008.tgfilter2(c)
    return baka.check_set_AzayakaSin(c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c62200008.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c62200008.op2(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c62200008.tgfilter2,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
        Duel.Draw(1-tp,1,REASON_EFFECT)
    end
end