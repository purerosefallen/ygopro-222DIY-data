--利维亚桑·马格纳
local m=47570100
local cm=_G["c"..m]
function c47570100.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,nil,2,3,c47570100.lcheck)
    c:EnableReviveLimit()
    --race
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0)
    e1:SetCode(EFFECT_ADD_RACE)
    e1:SetValue(RACE_SEASERPENT)
    c:RegisterEffect(e1) 
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER))
    e2:SetValue(1)
    c:RegisterEffect(e2) 
    local e3=e2:Clone()
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetValue(800)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e4)
    --spsummon
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e5:SetProperty(EFFECT_FLAG_DELAY)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EVENT_TO_GRAVE)
    e5:SetCountLimit(1)
    e5:SetCondition(c47570100.tfcon)
    e5:SetTarget(c47570100.sptg)
    e5:SetOperation(c47570100.spop)
    c:RegisterEffect(e5)
end
function c47570100.lcheck(g,lc)
    return g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WATER)
end
function c47570100.tfcfilter(c,tp)
    return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_MONSTER) and c:GetPreviousControler()==tp
end
function c47570100.tfcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c47570100.tfcfilter,1,nil,tp)
end
function c47570100.spfilter(c,e,tp)
    return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47570100.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47570100.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c47570100.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47570100.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end