--Spiral Drill's Final Battle
function c32912380.initial_effect(c)
    c:SetUniqueOnField(1,0,32912380)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --recover
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(32912380,1))
    e2:SetCategory(CATEGORY_RECOVER)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EVENT_BATTLE_DAMAGE)
    e2:SetCondition(c32912380.reccon)
    e2:SetTarget(c32912380.rectg)
    e2:SetOperation(c32912380.recop)
    c:RegisterEffect(e2)
    --avoid battle damage
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(c32912380.target)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    --to hand
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_GRAVE)
    e4:SetCondition(aux.exccon)
    e4:SetCost(aux.bfgcost)
    e4:SetTarget(c32912380.thtg)
    e4:SetOperation(c32912380.thop)
    c:RegisterEffect(e4)
end
function c32912380.reccon(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp and eg:GetFirst():IsControler(tp) and eg:GetFirst():IsSetCard(0x205)
end
function c32912380.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(ev)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function c32912380.recop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Recover(p,d,REASON_EFFECT)
end
function c32912380.target(e,c)
    return c:IsSetCard(0x205)
end
function c32912380.thfilter(c)
    return c:IsSetCard(0x205) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(32912380) and c:IsAbleToHand()
end
function c32912380.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c32912380.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c32912380.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c32912380.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end