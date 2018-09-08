--金刚晶
local m=47510088
local cm=_G["c"..m]
function c47510088.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,47510088)
    e1:SetCondition(c47510088.condition)
    e1:SetTarget(c47510088.target)
    e1:SetOperation(c47510088.activate)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,47510088)
    e2:SetLabel(0)
    e2:SetCost(c47510088.cost)
    e2:SetTarget(c47510088.sptg)
    e2:SetOperation(c47510088.spop)
    c:RegisterEffect(e2)
end
function c47510088.condition(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
end
function c47510088.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c47510088.vfilter(c,e,tp)
    return c:IsSetCard(0x5da) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47510088.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47510088.vfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c47510088.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47510088.vfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47510088.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c47510088.splimit(e,c)
    return not c:IsSetCard(0x5da)
end
function c47510088.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    e:SetLabel(100)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
        and Duel.CheckReleaseGroup(tp,nil,1,nil) end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c47510088.cfilter(c,e,tp,ft)
    local lv=c:GetLevel()
    return lv>0 and Duel.IsExistingMatchingCard(c47510088.spfilter,tp,LOCATION_DECK,0,1,nil,lv+1,e,tp)
        and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
function c47510088.spfilter(c,lv,e,tp)
    return c:IsLevel(lv) and (c:IsSetCard(0x5da) or c:IsSetCard(0x5de)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47510088.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if chk==0 then
        if e:GetLabel()~=100 then return false end
        e:SetLabel(0)
        return ft>-1 and Duel.CheckReleaseGroup(tp,c47510088.cfilter,1,nil,e,tp,ft)
    end
    local rg=Duel.SelectReleaseGroup(tp,c47510088.cfilter,1,1,nil,e,tp,ft)
    e:SetLabel(rg:GetFirst():GetLevel())
    Duel.Release(rg,REASON_COST)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c47510088.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local lv=e:GetLabel()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47510088.spfilter,tp,LOCATION_DECK,0,1,1,nil,lv+1,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end