--高达MK-III试作8号机
local m=47530024
local cm=_G["c"..m]
function c47530024.initial_effect(c)
    c:EnableReviveLimit()
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
    --synchro summon
    aux.AddSynchroMixProcedure(c,c47530024.matfilter1,nil,nil,aux.NonTuner(c47530024.matfilter2),1,99)  
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47530024.psplimit)
    c:RegisterEffect(e1)  
    --atkup
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_BATTLE_DESTROYING)
    e2:SetCondition(aux.bdocon)
    e2:SetOperation(c47530024.atkop)
    c:RegisterEffect(e2)
    --indes
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c47530024.inmcon)
    e3:SetValue(c47530024.efilter)
    c:RegisterEffect(e3)  
    --rank2
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47530024,1))
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_UPDATE_ATTACK)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(c47530024.r2con)
    e4:SetValue(1000)
    c:RegisterEffect(e4)  
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(47530024,1))
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCondition(c47530024.r2con)
    e5:SetValue(1)
    c:RegisterEffect(e5)  
    --rank1
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(47530024,0))
    e6:SetCategory(CATEGORY_DAMAGE)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e6:SetCode(EVENT_BATTLE_DAMAGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCondition(c47530024.r2con)
    e6:SetOperation(c47530024.op)
    c:RegisterEffect(e6)
    --rank3
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e7:SetCode(EVENT_CHAIN_SOLVING)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCondition(c47530024.discon)
    e7:SetOperation(c47530024.disop)
    c:RegisterEffect(e7) 
end
c47530024.list={
        CATEGORY_DESTROY,
        CATEGORY_RELEASE,
        CATEGORY_REMOVE,
        CATEGORY_TOHAND,
        CATEGORY_TODECK,
        CATEGORY_TOGRAVE,
        CATEGORY_DECKDES,
        CATEGORY_HANDES,
        CATEGORY_POSITION,
        CATEGORY_CONTROL,
        CATEGORY_DISABLE,
        CATEGORY_DISABLE_SUMMON,
        CATEGORY_EQUIP,
        CATEGORY_DAMAGE,
        CATEGORY_RECOVER,
        CATEGORY_ATKCHANGE,
        CATEGORY_DEFCHANGE,
        CATEGORY_COUNTER,
        CATEGORY_LVCHANGE,
        CATEGORY_NEGATE,
}
function c47530024.nfilter(c)
    return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c47530024.discon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not e:GetHandler():GetFlagEffect(47530024)>=3 then return end
    if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
    if c47530024.nfilter(re:GetHandler()) then return true end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    if g and g:IsExists(c47530024.nfilter,1,nil) then return true end
    local res,ceg,cep,cev,re,r,rp=Duel.CheckEvent(re:GetCode())
    if res and ceg and ceg:IsExists(c47530024.nfilter,1,nil) then return true end
    for i,ctg in pairs(c47530024.list) do
        local ex,tg,ct,p,v=Duel.GetOperationInfo(ev,ctg)
        if tg then
            if tg:IsExists(c47530024.nfilter,1,c) then return true end
        elseif v and v>0 and Duel.IsExistingMatchingCard(c47530024.nfilter,tp,v,0,1,nil) then
            return true
        end
    end
    return false
end
function c47530024.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.NegateEffect(ev)
end
function c47530024.op(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(1-tp,ev,REASON_EFFECT)
end
function c47530024.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
    c:RegisterFlagEffect(47530024,RESET_EVENT+0x7e0000,0,1)    
end
function c47530024.r1con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(47530024)>=1
end
function c47530024.r2con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(47530024)>=2
end
function c47530024.psplimit(e,c)
    return not c:IsRace(RACE_MACHINE)
end
function c47530024.matfilter1(c)
    return c:IsType(TYPE_TUNER) and c:IsRace(RACE_MACHINE)
end
function c47530024.matfilter2(c)
    return c:IsRace(RACE_MACHINE)
end
function c47530024.inmcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c47530024.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end