--T·F Cybertron
function c50218220.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --atk & def
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e2:SetValue(300)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xcb2))
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e3)
    --special summon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(50218220,0))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetCountLimit(1)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCost(c50218220.spcost)
    e4:SetTarget(c50218220.sptg)
    e4:SetOperation(c50218220.spop)
    c:RegisterEffect(e4)
end
function c50218220.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    e:SetLabel(100)
    if chk==0 then return true end
end
function c50218220.filter1(c,e,tp)
    return Duel.IsExistingMatchingCard(c50218220.filter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetOriginalAttribute())
        and Duel.GetMZoneCount(tp,c)>0
end
function c50218220.filter2(c,e,tp,att)
    return c:IsSetCard(0xcb2) and c:GetOriginalAttribute()~=att and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c50218220.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        if e:GetLabel()~=100 then return false end
        e:SetLabel(0)
        return Duel.CheckReleaseGroup(tp,c50218220.filter1,1,nil,e,tp)
    end
    local rg=Duel.SelectReleaseGroup(tp,c50218220.filter1,1,1,nil,e,tp)
    e:SetLabel(rg:GetFirst():GetOriginalAttribute())
    Duel.Release(rg,REASON_COST)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c50218220.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local att=e:GetLabel()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c50218220.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,att)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end