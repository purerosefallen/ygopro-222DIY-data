--紧急回避
local m=47530021
local cm=_G["c"..m]
function c47530021.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCondition(c47530021.condition)
    e1:SetCost(c47530021.cost)
    e1:SetTarget(c47530021.target)
    e1:SetOperation(c47530021.activate)
    c:RegisterEffect(e1)
    --act in hand
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e2:SetCondition(c47530021.handcon)
    c:RegisterEffect(e2)   
    --destroy replace
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EFFECT_DESTROY_REPLACE)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetTarget(c47530021.reptg)
    e3:SetValue(c47530021.repval)
    e3:SetOperation(c47530021.repop)
    c:RegisterEffect(e3) 
end
c47530021.is_named_with_EFSF=1
function c47530021.IsEFSF(c)
    local m=_G["c"..c:GetCode()]
    return m and m.is_named_with_EFSF
end
function c47530021.spfilter(c)
    return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c47530021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,c47530021.spfilter,1,nil) end
    local g=Duel.SelectReleaseGroup(tp,c47530021.spfilter,1,1,nil)
    Duel.Release(g,REASON_COST)
end
function c47530021.repfilter(c,tp)
    return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsLocation(LOCATION_MZONE)
        and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c47530021.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c47530021.repfilter,1,nil,tp) end
    return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c47530021.repval(e,c)
    return c47530021.repfilter(c,e:GetHandlerPlayer())
end
function c47530021.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
function c47530021.condition(e,tp,eg,ep,ev,re,r,rp)
    for i=1,ev do
        local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
        if tgp~=tp and (te:IsActiveType(TYPE_MONSTER) or te:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(i) then
            return true
        end
    end
    return false
end
function c47530021.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local ng=Group.CreateGroup()
    local dg=Group.CreateGroup()
    for i=1,ev do
        local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
        if tgp~=tp and (te:IsActiveType(TYPE_MONSTER) or te:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(i) then
            local tc=te:GetHandler()
            ng:AddCard(tc)
            if tc:IsOnField() and tc:IsRelateToEffect(te) and not tc:IsHasEffect(EFFECT_CANNOT_TO_DECK) and Duel.IsPlayerCanSendtoDeck(tp,tc) then
                dg:AddCard(tc)
            end
        end
    end
    Duel.SetTargetCard(dg)
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,ng,ng:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,dg,dg:GetCount(),0,0)
end
function c47530021.activate(e,tp,eg,ep,ev,re,r,rp)
    local dg=Group.CreateGroup()
    for i=1,ev do
        local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
        if tgp~=tp and (te:IsActiveType(TYPE_MONSTER) or te:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.NegateActivation(i) then
            local tc=te:GetHandler()
            if tc:IsRelateToEffect(e) and tc:IsRelateToEffect(te) and not tc:IsHasEffect(EFFECT_CANNOT_TO_DECK) and Duel.IsPlayerCanSendtoDeck(tp,tc) then
                tc:CancelToGrave()
                dg:AddCard(tc)
            end
        end
    end
    Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)
end
function c47530021.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x5d5)
end
function c47530021.handcon(e)
    return Duel.IsExistingMatchingCard(c47530021.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end