--驱影之阳-白金银火
function c4212114.initial_effect(c)
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,nil,2,99,function(g,lc)return g:IsExists(Card.IsCode,1,nil,4212014) end)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(4212114,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,4212114)
    e1:SetCost(c4212114.spcost)
    e1:SetTarget(c4212114.sptg,false)
    e1:SetOperation(c4212114.spop,false)
    c:RegisterEffect(e1)
    --special summon(deck)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(4212114,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_REMOVE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,4212114)
    e2:SetTarget(c4212114.sptg,true)
    e2:SetOperation(c4212114.spop,true)
    c:RegisterEffect(e2)
    --atk gain
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e3:SetTarget(c4212114.atktg)
    e3:SetValue(500)
    c:RegisterEffect(e3)
    --untarget
    local e4=e3:Clone()
    e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e4:SetValue(aux.tgoval)
    c:RegisterEffect(e4)  
end
function c4212114.cfilter(c,g)
    return g:IsContains(c)
end
function c4212114.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local lg=e:GetHandler():GetLinkedGroup()
    if chk==0 then return Duel.CheckReleaseGroup(tp,c4212114.cfilter,1,nil,lg) end
    local g=Duel.SelectReleaseGroup(tp,c4212114.cfilter,1,1,nil,lg)
    Duel.Release(g,REASON_COST)
end
function c4212114.spfilter(c,e,tp)
    return c:IsSetCard(0xa2a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c4212114.sploc(flag)
    return LOCATION_DECK + (flag and { LOCATION_GRAVE } or { 0x0 })[1]
end
function c4212114.sptg(e,tp,eg,ep,ev,re,r,rp,chk,flag)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
        and Duel.IsExistingMatchingCard(c4212114.spfilter,tp,c4212114.sploc(flag),0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,c4212114.sploc(flag))
end
function c4212114.spop(e,tp,eg,ep,ev,re,r,rp,flag)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c4212114.spfilter,tp,c4212114.sploc(flag),0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c4212114.atktg(e,c)
    return c:GetMutualLinkedGroupCount()>0
end