--天司长的依代
local m=47578914
local cm=_G["c"..m]
function c47578914.initial_effect(c)
    --destroy
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCode(EVENT_DESTROYED)
    e1:SetCondition(c47578914.spcon1)
    e1:SetCost(c47578914.spcost)
    e1:SetTarget(c47578914.sptg)
    e1:SetOperation(c47578914.spop)
    c:RegisterEffect(e1)
    --salvage
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCost(c47578914.thcost)
    e2:SetCondition(aux.exccon)
    e2:SetTarget(c47578914.target)
    e2:SetOperation(c47578914.activate)
end
function c47578914.cfilter(c,tp)
    return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
        and bit.band(c:GetPreviousRaceOnField(),RACE_FAIRY)~=0
end
function c47578914.spcon1(e,tp,eg,ep,ev,re,r,rp)
    return rp==1-tp and eg:IsExists(c47578914.cfilter,1,e:GetHandler(),tp)
end
function c47578914.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c47578914.spfilter(c,e,tp)
    return c:IsSetCard(0x5de) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsType(TYPE_LINK)
end 
function c47578914.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47578914.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c47578914.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47578914.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
       local e1=Effect.CreateEffect(e:GetHandler())
       e1:SetType(EFFECT_TYPE_SINGLE)
       e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
       e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE+EFFECT_INDESTRUCTABLE_EFFECT)
       e1:SetValue(1)
       e1:SetReset(RESET_PHASE+PHASE_END)
       g:GetFirst():RegisterEffect(e1)
    end
end
function c47578914.cfilter(c)
    return c:IsSetCard(0x5de) and c:IsAbleToRemoveAsCost()
end
function c47578914.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
        and Duel.IsExistingMatchingCard(c47578914.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c47578914.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    g:AddCard(e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c47578914.ssfilter(c,e,tp)
    return c:IsSetCard(0x5de) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47578914.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47578914.ssfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c47578914.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47578914.ssfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end