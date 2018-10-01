--南南西的守护神 阿尼拉
local m=47520001
local cm=_G["c"..m]
function c47520001.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFun2(c,c47520001.ffilter,aux.FilterBoolFunction(Card.IsType,TYPE_PENDULUM),true)   
    --special summon rule
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetRange(LOCATION_EXTRA)
    e0:SetValue(SUMMON_TYPE_FUSION)
    e0:SetCondition(c47520001.spcon)
    e0:SetOperation(c47520001.spop)
    c:RegisterEffect(e0) 
    --shinramanshyou
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47520001,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(c47520001.atkcon)
    e1:SetOperation(c47520001.atkop)
    c:RegisterEffect(e1)
    --ryuginkoushyou
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCountLimit(1,47520001)
    e2:SetTarget(c47520001.efftg)
    e2:SetOperation(c47520001.effop)
    c:RegisterEffect(e2)
end
function c47520001.ffilter(c)
    return (c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_PENDULUM)) or (c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_BEASTWARRIOR))
end
function c47520001.spfilter(c,fc)
    return c47520001.ffilter(c) and c:IsCanBeFusionMaterial(fc)
end
function c47520001.spfilter1(c,tp,g)
    return g:IsExists(c47520001.spfilter2,1,c,tp,c)
end
function c47520001.spfilter2(c,tp,mc)
    return Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c47520001.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local g=Duel.GetReleaseGroup(tp):Filter(c47520001.spfilter,nil,c)
    return g:IsExists(c47520001.spfilter1,1,nil,tp,g) and c:IsFacedown()
end
function c47520001.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.GetReleaseGroup(tp):Filter(c47520001.spfilter,nil,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g1=g:FilterSelect(tp,c47520001.spfilter1,1,1,nil,tp,g)
    local mc=g1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g2=g:FilterSelect(tp,c47520001.spfilter2,1,1,mc,tp,mc)
    g1:Merge(g2)
    c:SetMaterial(g1)
    Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c47520001.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c47520001.atkfilter(c)
    return c:IsType(TYPE_MONSTER)
end
function c47520001.atkop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    local dg=Group.CreateGroup()
    local c=e:GetHandler()
    while tc do
        local preatk=tc:GetAttack()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(c47520001.value)
        tc:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        tc:RegisterEffect(e2)
        if preatk~=0 and tc:IsAttackAbove(1000) then dg:AddCard(tc) end
        tc=g:GetNext()
    end
    Duel.Destroy(dg,REASON_EFFECT)
end  
function c47520001.value(e,c)
    local tp=e:GetHandlerPlayer()
    local att=0
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    while tc do
        att=bit.bor(att,tc:GetAttribute())
        tc=g:GetNext()
    end
    local ct=0
    while att~=0 do
        if bit.band(att,0x1)~=0 then ct=ct+1 end
        att=bit.rshift(att,1)
    end
    return ct*-500
end
function c47520001.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
end
function c47520001.effop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(1500)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
        tc:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        tc:RegisterEffect(e2)
        local e3=Effect.CreateEffect(e:GetHandler())
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_CANNOT_DISABLE)
        e3:SetValue(1)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
        tc:RegisterEffect(e3)
        local e4=e3:Clone()
        e4:SetCode(EFFECT_CANNOT_DISEFFECT)
        tc:RegisterEffect(e4)
        tc=g:GetNext()
    end
end