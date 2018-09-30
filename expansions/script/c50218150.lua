--终焉数码兽 OMEGA
function c50218150.initial_effect(c)
    c:EnableReviveLimit()
    --spsummon limit
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.FALSE)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c50218150.spcon)
    e2:SetOperation(c50218150.spop)
    c:RegisterEffect(e2)
    --indes
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e4)
    local e5=e3:Clone()
    e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    c:RegisterEffect(e5)
    --to hand
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_TOHAND)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e6:SetCode(EVENT_BATTLE_START)
    e6:SetCountLimit(1)
    e6:SetTarget(c50218150.thtg)
    e6:SetOperation(c50218150.thop)
    c:RegisterEffect(e6)
    --to hand
    local e7=Effect.CreateEffect(c)
    e7:SetCategory(CATEGORY_TOHAND)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e7:SetCode(EVENT_LEAVE_FIELD)
    e7:SetTarget(c50218150.target)
    e7:SetOperation(c50218150.activate)
    c:RegisterEffect(e7)
end
function c50218150.spfilter(c)
    return c:IsCode(50218139,50218140) and c:IsAbleToRemoveAsCost()
end
function c50218150.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c50218150.spfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,2,nil)
end
function c50218150.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c50218150.spfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,2,2,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c50218150.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local tc=c:GetBattleTarget()
    if chk==0 then return tc and tc:IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
end
function c50218150.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetAttacker()
    if c==tc then tc=Duel.GetAttackTarget() end
    if tc and tc:IsRelateToBattle() then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end
function c50218150.thfilter(c)
    return c:IsCode(50218139,50218140) and c:IsFaceup() and c:IsAbleToHand()
end
function c50218150.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c50218150.thfilter(chkc) end
    if chk==0 then return true end
    if Duel.IsExistingTarget(c50218150.thfilter,tp,LOCATION_REMOVED,0,2,nil)
    then Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
         local g=Duel.SelectTarget(tp,c50218150.thfilter,tp,LOCATION_REMOVED,0,2,2,nil)
         Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
    end
end
function c50218150.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local sg=g:Filter(Card.IsRelateToEffect,nil,e)
    if sg:GetCount()>0 then
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
    end
end