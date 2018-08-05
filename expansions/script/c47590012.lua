--双子天司 哈鲁特·玛鲁特
local m=47590012
local cm=_G["c"..m]
function c47590012.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,nil,2,2,c47590012.lcheck)
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(c47590012.atkcon)
    e1:SetTarget(c47590012.atktg)
    e1:SetOperation(c47590012.atkop)
    c:RegisterEffect(e1)
    --counter
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47590012,0))
    e2:SetCategory(CATEGORY_COUNTER)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c47590012.cttg)
    e2:SetOperation(c47590012.ctop)
    c:RegisterEffect(e2)
    --disable
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_DISABLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(0,LOCATION_MZONE)
    e3:SetTarget(c47590012.distg)
    c:RegisterEffect(e3)
    --atk def
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_UPDATE_ATTACK)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e4:SetCondition(c47590012.adcon)
    e4:SetTarget(c47590012.adtg)
    e4:SetValue(-1000)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e5)
end
function c47590012.lcheck(g)
    return g:GetClassCount(Card.GetLinkAttribute)==g:GetCount()
end
function c47590012.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c47590012.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    if not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) then
        Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1500)
    end
end
function c47590012.atkop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    if g:GetCount()>0 then
        local sc=g:GetFirst()
        while sc do
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            e1:SetValue(-1500)
            sc:RegisterEffect(e1)
            sc=g:GetNext()
        end
    end
end
function c47590012.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c47590012.ctop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    while tc do
        if not tc:IsCanAddCounter(0x5d2,1) then
            tc:EnableCounterPermit(0x5d2)
        end
        tc:AddCounter(0x5d2,1)
    end
end
function c47590012.distg(e,c)
    return c:GetCounter(0x5d2)>0
end
function c47590012.adcon(e)
    return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and Duel.GetAttackTarget()
end
function c47590012.adtg(e,c)
    local bc=c:GetBattleTarget()
    return bc and c:GetCounter(0x5d2)~=0
end