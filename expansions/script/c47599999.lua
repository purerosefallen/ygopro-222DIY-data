--至高神Z
function c47599999.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,12,12)
    c:EnableReviveLimit()
    --spsummon limit
    local e0=Effect.CreateEffect(c)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    e0:SetValue(aux.xyzlimit)
    c:RegisterEffect(e0) 
    --basestaus
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_SET_BASE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetValue(c47599999.atkval)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_SET_BASE_DEFENSE)
    e2:SetValue(c47599999.atkval)
    c:RegisterEffect(e2)     
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_UNRELEASABLE_SUM)
    e4:SetCondition(c47599999.inmcon)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
    c:RegisterEffect(e5)
    --Akashic Code Change
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47599999,0))
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_CHAINING)
    e3:SetRange(LOCATION_MZONE)
    e3:SetOperation(c47599999.disop)
    c:RegisterEffect(e3)
end
function c47599999.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function c47599999.atkfilter(c)
    return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRankAbove(1)
end
function c47599999.atkval(e,c)
    local g=e:GetHandler():GetOverlayGroup():Filter(c47599999.atkfilter,nil)
    return g:GetSum(Card.GetRank)*500
end
function c47599999.ovfilter(c)
    return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_XYZ) 
end
function c47599999.inmcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayGroup():IsExists(c47599999.ovfilter,1,nil)
end
function c47599999.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.SelectYesNo(tp,aux.Stringid(47599999,0)) then
        local g=Group.CreateGroup()
        Duel.ChangeTargetCard(ev,g)
        Duel.ChangeChainOperation(ev,c47599999.repop)
        local rc=re:GetHandler()
        if Duel.Remove(rc,POS_FACEDOWN,REASON_RULE) then
        Duel.BreakEffect()
        c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
        end
    end
end
function c47599999.repop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
end