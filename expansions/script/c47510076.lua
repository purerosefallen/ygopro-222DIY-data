--地裂的星晶兽 泰坦
local m=47510076
local cm=_G["c"..m]
function c47510076.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,3,c47510076.lcheck)
    c:EnableReviveLimit()  
    --indes
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(c47510076.intg)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e2)
    --pos change
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_POSITION)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTarget(c47510076.target)
    e3:SetOperation(c47510076.operation)
    c:RegisterEffect(e3) 
end
function c47510076.lcheck(g)
    return g:IsExists(Card.IsLinkSetCard,1,nil,0x5da) or g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_EARTH)
end
function c47510076.intg(e,c)
    return c:IsType(TYPE_PENDULUM) or c:IsAttribute(ATTRIBUTE_EARTH)
end
function c47510076.filter(c)
    return not c:IsPosition(POS_FACEUP_DEFENSE) and c:IsCanChangePosition()
end
function c47510076.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47510076.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c47510076.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c47510076.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetRange(LOCATION_MZONE)
    e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(c47510076.target)
    e1:SetValue(c47510076.efilter)
    c:RegisterEffect(e1)
end
function c47510076.target(e,c)
    local te,g=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
    return not te or not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or not g or not g:IsContains(c)
end
function c47510076.efilter(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end