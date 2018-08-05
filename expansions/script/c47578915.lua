--天司的裁决
local m=47578915
local cm=_G["c"..m]
function c47578915.initial_effect(c)
    --atkup
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_ACTIVATE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCountLimit(1,47578915)
    e3:SetCost(c47578915.descost)
    e3:SetTarget(c47578915.destg)
    e3:SetOperation(c47578915.desop)
    c:RegisterEffect(e3)
    --salvage
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_ACTIVATE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,47578915)
    e2:SetCost(c47578915.thcost)
    e2:SetCondition(aux.exccon)
    e2:SetTarget(c47578915.target)
    e2:SetOperation(c47578915.activate)
    c:RegisterEffect(e2)
end
function c47578915.costfilter(c)
    return c:IsFaceup() and c:IsRace(RACE_FAIRY)
        and Duel.IsExistingMatchingCard(c47578915.filter,0,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetAttack())
end
function c47578915.filter(c,atk)
    return c:IsFaceup() and c:IsAttackBelow(atk)
end
function c47578915.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,c47578915.costfilter,1,nil) end
    local g=Duel.SelectReleaseGroup(tp,c47578915.costfilter,1,1,nil)
    e:SetLabel(g:GetFirst():GetAttack())
    Duel.Release(g,REASON_COST)
end
function c47578915.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetMatchingGroup(c47578915.filter,0,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetLabel())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c47578915.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c47578915.filter,0,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetLabel())
    Duel.Destroy(g,REASON_EFFECT)
end
function c47578915.cfilter(c)
    return c:IsSetCard(0x5de) and c:IsAbleToRemoveAsCost()
end
function c47578915.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
        and Duel.IsExistingMatchingCard(c47578915.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c47578915.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    g:AddCard(e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c47578915.spfilter(c,e,tp)
    return c:IsSetCard(0x5de) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47578915.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47578915.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c47578915.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47578915.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end