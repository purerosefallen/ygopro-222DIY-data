--天司原核
local m=47517001
local cm=_G["c"..m]
function c47517001.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,nil,2,2,c47517001.lcheck)
    c:EnableReviveLimit()   
    --spssummon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,47517001)
    e1:SetCondition(c47517001.con)
    e1:SetTarget(c47517001.tgtg)
    e1:SetOperation(c47517001.tgop)
    c:RegisterEffect(e1)
    --to hand
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c47517001.destg)
    e2:SetOperation(c47517001.desop)
    c:RegisterEffect(e2) 
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCondition(c47517001.spcon2)
    e3:SetTarget(c47517001.sptg2)
    e3:SetOperation(c47517001.spop2)
    c:RegisterEffect(e3) 
end
function c47517001.lcheck(g,lc)
    return g:IsExists(Card.IsRace,1,nil,RACE_FAIRY)
end
function c47517001.tgfilter(c,e,tp,dam)
    return c:IsRace(RACE_FAIRY) and c:IsLevelAbove(7) and c:IsAbleToGrave()
end
function c47517001.con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c47517001.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47517001.tgfilter,tp,LOCATION_DECK,0,1,nil,e,tp,ev) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c47517001.tgop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c47517001.tgfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,ev)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,nil,REASON_EFFECT)
    end
end
function c47517001.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_SZONE,0,1,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_SZONE,0,1,1,c)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c47517001.tffilter(c,e,tp,zone)
    return c:IsType(TYPE_PENDULUM)
end
function c47517001.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then    
        local g=Duel.SelectMatchingCard(tp,c47517001.tffilter,tp,LOCATION_HAND,0,1,1,nil)
        if g:GetCount()>0 then
            local tc1=g:GetFirst()
            if tc1 and Duel.MoveToField(tc1,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
            local e4=Effect.CreateEffect(tc1)
            e4:SetType(EFFECT_TYPE_SINGLE)
            e4:SetRange(LOCATION_SZONE)
            e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
            e4:SetCode(EFFECT_LINK_SPELL_KOISHI)
            e4:SetValue(LINK_MARKER_TOP+LINK_MARKER_TOP_RIGHT)
            tc1:RegisterEffect(e4)
            end
        end
    end
end
function c47517001.spcon2(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c47517001.spfilter(c,e,tp)
    return c:IsRace(RACE_FAIRY) and c:IsLevelAbove(7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47517001.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47517001.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c47517001.spop2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47517001.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end