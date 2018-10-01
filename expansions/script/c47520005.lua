--西的守护神 玛琪拉
local m=47520005
local cm=_G["c"..m]
function c47520005.initial_effect(c)
    c:EnableReviveLimit()
    c:EnableCounterPermit(0x5d8)
    c:SetCounterLimit(0x5d8,3)
    --material
    c:EnableReviveLimit() 
    aux.AddXyzProcedureLevelFree(c,c47520005.mfilter,c47520005.xyzcheck,2,2)
    aux.EnablePendulumAttribute(c,false)  
    --atkup
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(c47520005.cost)
    e1:SetOperation(c47520005.atkop)
    c:RegisterEffect(e1)
    --def down
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_BATTLE_START)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c47520005.dbcon)
    e2:SetOperation(c47520005.dbop)
    c:RegisterEffect(e2)
    --koon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47520005,0))
    e3:SetCategory(CATEGORY_ATKCHANGE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_ATTACK_ANNOUNCE)
    e3:SetTarget(c47520005.target)
    e3:SetOperation(c47520005.opd1)
    c:RegisterEffect(e3)
end
function c47520005.mfilter(c)
    return c:IsLevel(8)
end
function c47520005.xyzcheck(g)
    return g:IsExists(Card.IsSetCard,1,nil,0x5dd) or g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_EARTH)
end
function c47520005.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47520005.filter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.SetChainLimit(aux.FALSE)
end
function c47520005.opd1(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        e:GetHandler():AddCounter(0x5d8,1)
    end
end
function c47520005.dbcon(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetAttacker()
    if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
    return tc and tc:IsControler(tp) and tc:IsAttribute(ATTRIBUTE_EARTH)
end
function c47520005.dbop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetAttackTarget()
    if not tc then return end
    if tc:IsControler(tp) then tc=Duel.GetAttacker() end
    c:CreateRelation(tc,RESET_EVENT+RESETS_STANDARD)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_DISABLE)
    e1:SetCondition(c47520005.discon2)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
    tc:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_DISABLE_EFFECT)
    e2:SetCondition(c47520005.discon2)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
    tc:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetCondition(c47520005.discon2)
    e3:SetValue(-1850)
    e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
    tc:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_UPDATE_ATTACK)
    tc:RegisterEffect(e4)
end
function c47520005.discon2(e)
    return e:GetOwner():IsRelateToCard(e:GetHandler())
end
function c47520005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetCounter(0x5d8)>0 and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
    local ct=e:GetHandler():GetCounter(0x5d8)
    e:SetLabel(ct)
    e:GetHandler():RemoveCounter(tp,0x5d8,ct,REASON_COST)
end
function c47520005.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
    if g:GetCount()>0 then
        local sc=g:GetFirst()
        local ct=e:GetLabel()
        if ct==1 then
            while sc do 
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_ATTACK)
                e1:SetValue(1000)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                sc:RegisterEffect(e1)
                local e2=e1:Clone()
                e2:SetCode(EFFECT_UPDATE_DEFENSE)
                sc:RegisterEffect(e2)
                local e3=Effect.CreateEffect(c)
                e3:SetType(EFFECT_TYPE_SINGLE)     
                e3:SetCode(EFFECT_IMMUNE_EFFECT)
                e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
                e3:SetTargetRange(LOCATION_MZONE,0)
                e3:SetTarget(c47520005.etg)
                e3:SetValue(c47520005.efilter)
                e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                sc:RegisterEffect(e3)
                sc=g:GetNext()
                end
        elseif ct==2 then
            while sc do
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_ATTACK)
                e1:SetValue(1500)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                sc:RegisterEffect(e1)
                local e2=e1:Clone()
                e2:SetCode(EFFECT_UPDATE_DEFENSE)
                sc:RegisterEffect(e2)
                local e3=Effect.CreateEffect(c)
                e3:SetType(EFFECT_TYPE_SINGLE)
                e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
                e3:SetValue(1)
                e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                sc:RegisterEffect(e3)
                local e4=e3:Clone()
                e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
                sc:RegisterEffect(e4)
                local e5=Effect.CreateEffect(c)
                e5:SetType(EFFECT_TYPE_SINGLE)     
                e5:SetCode(EFFECT_IMMUNE_EFFECT)
                e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
                e5:SetTargetRange(LOCATION_MZONE,0)
                e5:SetTarget(c47520005.etg)
                e5:SetValue(c47520005.efilter)
                e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                sc:RegisterEffect(e5)
                sc=g:GetNext()
            end
        elseif ct==3 then
            while sc do 
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_ATTACK)
                e1:SetValue(2000)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                sc:RegisterEffect(e1)
                local e2=e1:Clone()
                e2:SetCode(EFFECT_UPDATE_DEFENSE)
                sc:RegisterEffect(e2)
                local e3=Effect.CreateEffect(c)
                e3:SetType(EFFECT_TYPE_SINGLE)
                e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
                e3:SetValue(1)
                e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                sc:RegisterEffect(e3)
                local e4=Effect.CreateEffect(c)
                e4:SetType(EFFECT_TYPE_SINGLE)
                e4:SetCode(EFFECT_IMMUNE_EFFECT)
                e4:SetValue(c47520005.efilter2)
                e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                e4:SetOwnerPlayer(tp)
                sc=g:GetNext()
            end
        end
    end
end
function c47520005.etg(e,c)
    local te,g=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
    return not te or not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or not g or not g:IsContains(c)
end
function c47520005.efilter(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c47520005.efilter2(e,re)
    return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end