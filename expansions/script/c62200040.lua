--外典救世主 漂泊的华欲-孕剑姬
local m=62200040
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c62200000")end,function() require("script/c62200000") end)
cm.named_with_ApocryphaSavior=true
cm.named_with_AzayakaSin=true
cm.named_with_PregnantSwordHime=true
function cm.initial_effect(c)
    c:EnableCounterPermit(0x6621)
    c:EnableReviveLimit()
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e1)
    --changelp
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetCondition(cm.lpcon1)
    e2:SetOperation(cm.lpop)
    c:RegisterEffect(e2)
    --atkup
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetValue(cm.atkval)
    c:RegisterEffect(e3)
    --AddCounter
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(m,1))
    e4:SetCategory(CATEGORY_COUNTER)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCost(cm.addcost)
    e4:SetOperation(cm.addop)
    c:RegisterEffect(e4)
    --atkdown
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EFFECT_UPDATE_ATTACK)
    e5:SetCondition(cm.atkdwcon)
    e5:SetValue(cm.atkdwval)
    c:RegisterEffect(e5)
    --rec
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(m,2))
    e6:SetCategory(CATEGORY_RECOVER)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetCode(EVENT_FREE_CHAIN)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1)
    e6:SetCondition(cm.reccon)
    e6:SetTarget(cm.rectg)
    e6:SetOperation(cm.recop)
    c:RegisterEffect(e6)
    --COUNTER
    local e7=Effect.CreateEffect(c)
    e7:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e7:SetType(EFFECT_TYPE_QUICK_O)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCode(EVENT_CHAINING)
    e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e7:SetCondition(cm.discon)
    e7:SetCost(cm.discost)
    e7:SetTarget(cm.distg)
    e7:SetOperation(cm.disop)
    c:RegisterEffect(e7)
    --SearchCard
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(m,3))
    e8:SetCategory(CATEGORY_DRAW)
    e8:SetType(EFFECT_TYPE_IGNITION)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCondition(cm.shcon)
    e8:SetCost(cm.shcost)
    e8:SetTarget(cm.shtg)
    e8:SetOperation(cm.shop)
    c:RegisterEffect(e8)
end
--
function cm.lpcon1(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function cm.lpop(e,tp,eg,ep,ev,re,r,rp)
    Duel.SetLP(tp,0)
end
--
function cm.atkval(e,c)
    return c:GetCounter(0x6621)*700
end
--
function cm.addcfilter(c)
    return not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.addcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,cm.addcfilter,1,nil) end
    local g=Duel.SelectReleaseGroup(tp,cm.addcfilter,1,1,nil)
    Duel.Release(g,REASON_COST)
end
function cm.addop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
    e:GetHandler():AddCounter(0x6621,1)
    end
end
--
function cm.atkdwcon(e,c)
    return e:GetHandler():GetCounter(0x6621)>=3
end
function cm.atkval(e,c)
    return c:GetAttack()/2
end
--
function cm.reccon(e,c)
    return e:GetHandler():GetCounter(0x6621)>=6
end
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local ct=Duel.GetCounter(tp,1,0,0x6621)
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(ct*300)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*300)
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local ct=Duel.GetCounter(tp,1,0,0x6621)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Recover(p,ct*3000,REASON_EFFECT)
end
--
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and e:GetHandler():GetCounter(0x6621)>=7
end
function cm.discfilter(c)
    return baka.check_set_PregnantSwordHime(c) and c:IsDiscardable()
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.discfilter(c),tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,cm.discfilter(c),1,1,REASON_COST+REASON_DISCARD,nil)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end
--
function cm.shcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetCounter(0x6621)>=10 and Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.shcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local ct=e:GetHandler():GetCounter(0x6621)
    if chk==0 then return ct>=10 and e:GetHandler():IsCanRemoveCounter(tp,0x6621,ct,REASON_COST) end
    e:GetHandler():RemoveCounter(tp,0x6621,ct,REASON_COST)
end
function cm.shtgfilter(c)
    return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function cm.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.shtgfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.shop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.shtgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
    Duel.BreakEffect()
    Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetCode(EFFECT_CANNOT_BP)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    end
end