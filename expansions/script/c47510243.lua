--不死之王 巫妖
local m=47510243
local cm=_G["c"..m]
function c47510243.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)  
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47510243.psplimit)
    c:RegisterEffect(e1)  
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,47510243)
    e2:SetCost(c47510243.spcost)
    e2:SetTarget(c47510243.sptg)
    e2:SetOperation(c47510243.spop)
    c:RegisterEffect(e2)  
    --serch
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,47510244)
    e3:SetTarget(c47510243.thtg2)
    e3:SetOperation(c47510243.thop2)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e4)  
    --sunmoneffect
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetRange(LOCATION_EXTRA)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetCountLimit(1,47510000)
    e5:SetCost(c47510243.cost)
    e5:SetOperation(c47510243.ssop)
    c:RegisterEffect(e5)
    c47510243.ss_effect=e5
end
function c47510243.pefilter(c)
    return c:IsRace(RACE_ZOMBIE) or c:IsSetCard(0x5da) or c:IsAttribute(ATTRIBUTE_DARK)
end
function c47510243.psplimit(e,c,tp,sumtp,sumpos)
    return not c47510243.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47510243.cfilter(c)
    return c:IsRace(RACE_ZOMBIE) and c:IsAbleToGraveAsCost()
end
function c47510243.cfilter1(c)
    return c:IsRace(RACE_ZOMBIE) and c:IsAbleToRemoveAsCost()
end
function c47510243.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(c47510243.cfilter,tp,LOCATION_HAND,0,1,c) and Duel.IsExistingMatchingCard(c47510243.cfilter1,tp,LOCATION_GRAVE,0,1,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c47510243.cfilter,tp,LOCATION_HAND,0,1,1,c)
    if Duel.SendtoGrave(g,REASON_COST) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local g=Duel.SelectMatchingCard(tp,c47510243.cfilter1,tp,LOCATION_GRAVE,0,1,1,c)
        Duel.Remove(g,POS_FACEUP,REASON_COST)
    end
end
function c47510243.spfilter(c,e,tp)
    return c:IsRace(RACE_ZOMBIE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47510243.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c47510243.spfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c47510243.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c47510243.spop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.SelectMatchingCard(tp,c47510243.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c47510243.thfilter(c)
    return c:IsRace(RACE_ZOMBIE) and c:IsAbleToHand() and c:IsFaceup()
end
function c47510243.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47510243.thfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c47510243.thop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47510243.thfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,tp,REASON_EFFECT)
    end
end
function c47510243.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c47510243.ssop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CHANGE_RACE)
    e1:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetValue(RACE_ZOMBIE)
    Duel.RegisterEffect(e1,tp)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetTargetRange(0,LOCATION_MZONE)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_ZOMBIE))
    e2:SetReset(RESET_PHASE+PHASE_END)
    e2:SetValue(c47510243.efilter1)
    Duel.RegisterEffect(e2,tp)
end
function c47510243.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end