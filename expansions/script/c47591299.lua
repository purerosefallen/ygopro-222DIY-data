--觉醒十天众 尼奥
local m=47591299
local cm=_G["c"..m]
function c47591299.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,nil,aux.NonTuner(c47591299.synfilter),1)
    c:EnableReviveLimit()
    --检索
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47591299,1))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCondition(c47591299.poscon)
    e1:SetTarget(c47591299.thtg)
    e1:SetOperation(c47591299.thop)
    c:RegisterEffect(e1)
    --disable
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47591299,0))
    e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c47591299.condition)
    e2:SetTarget(c47591299.target)
    e2:SetOperation(c47591299.operation)
    c:RegisterEffect(e2)
    --boost
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetValue(900)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e4)
    --mudeki
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetValue(1)
    c:RegisterEffect(e5)
    local e6=e5:Clone()
    e6:SetValue(aux.tgoval)
    c:RegisterEffect(e6)
end
function c47591299.synfilter(c)
    return c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_WIND)
end
function c47591299.poscon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c47591299.filter(c)
    return c:IsCode(47591009) and c:IsAbleToHand()
end
function c47591299.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47591299.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c47591299.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47591299.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c47591299.condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=re:GetHandler()
    return re:IsActiveType(TYPE_MONSTER) and rc~=c and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c47591299.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_CONTROL,eg,1,0,0)
    end
end
function c47591299.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=re:GetHandler()
    if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
        Duel.GetControl(rc,tp,PHASE_END,1)
    end
end