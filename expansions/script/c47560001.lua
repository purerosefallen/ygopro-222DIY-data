--超钢巨人 激钢神
local m=47560001
local c47560001=_G["c"..m]
function c47560001.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c47560001.spcon)
    e1:SetCountLimit(1,47560001)
    e1:SetValue(1)
    c:RegisterEffect(e1)  
    --special summon2
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_DECK)
    e2:SetCondition(c47560001.spcons)
    e2:SetCountLimit(1,47560001)
    e2:SetValue(1)
    c:RegisterEffect(e2) 
    --attack all
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_ATTACK_ALL)
    e3:SetValue(c47560001.atkfilter)
    c:RegisterEffect(e3)    
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TODECK)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetOperation(c47560001.tdop)
    c:RegisterEffect(e4)
    --immune
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EFFECT_IMMUNE_EFFECT)
    e5:SetValue(c47560001.efilter)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCode(EFFECT_IMMUNE_EFFECT)
    e6:SetCondition(c47560001.inmcon)
    e6:SetValue(c47560001.efilter1)
    c:RegisterEffect(e6)
    --disable
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD)
    e7:SetRange(LOCATION_MZONE)
    e7:SetTargetRange(0,LOCATION_MZONE)
    e7:SetCode(EFFECT_DISABLE)
    e7:SetTarget(c47560001.fuckexlinktg)
    e7:SetCondition(c47560001.fuckexlinkcon)
    c:RegisterEffect(e7)
end
function c47560001.filter(c)
    return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c47560001.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
        Duel.IsExistingMatchingCard(c47560001.filter,c:GetControler(),0,LOCATION_MZONE,1,nil)
end
function c47560001.filters(c)
    return c:IsFaceup() and c:IsExtraLinkState()
end
function c47560001.spcons(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
        Duel.IsExistingMatchingCard(c47560001.filters,c:GetControler(),0,LOCATION_MZONE,1,nil)
end
function c47560001.inmcon(e,c)
    return Duel.IsExistingMatchingCard(c47560001.filters,c:GetControler(),0,LOCATION_MZONE,1,nil)
end
function c47560001.tdfilter(c)
    return c:IsFaceup() and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end
function c47560001.tdop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
    local g=Duel.SelectMatchingCard(tp,c47560001.tdfilter,tp,LOCATION_SZONE+LOCATION_FZONE,0,1,1,nil)
    if g:GetCount()>0 then 
        Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
    end
end
function c47560001.atkfilter(e,c)
    return c:IsType(TYPE_LINK)
end
function c47560001.felfilter(e,c)
    return c:IsType(TYPE_LINK)
end
function c47560001.efilter(e,te)
    return te:IsActiveType(TYPE_MONSTER) and te:GetOwner():IsType(TYPE_LINK)
end
function c47560001.efilter1(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function c47560001.fuckexlinktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47560001.felfilter,tp,0,LOCATION_MZONE,1,nil) end
end
function c47560001.fuckexlinkcon(e,c)
    return Duel.IsExistingMatchingCard(c47560001.filters,c:GetControler(),0,LOCATION_MZONE,1,nil)
end