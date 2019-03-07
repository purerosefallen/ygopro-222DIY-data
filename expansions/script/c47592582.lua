--时空终焉·Ζ
function c47592582.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47592582,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMING_END_PHASE)
    e1:SetTarget(c47592582.target)
    e1:SetOperation(c47592582.activate)
    c:RegisterEffect(e1)
    --search
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47592582,1))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(c47592582.thtg)
    e2:SetOperation(c47592582.thop)
    c:RegisterEffect(e2)    
end
function c47592582.filter(c,e,tp)
    return c:IsType(TYPE_XYZ) and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47592582.olfilter(c)
    return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsFaceup()
end
function c47592582.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c47592582.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c47592582.olfilter,tp,0,LOCATION_MZONE,1,nil)end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c47592582.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c47592582.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) then
        local g=Duel.SelectMatchingCard(tp,c47592582.olfilter,tp,0,LOCATION_MZONE,1,1,nil)
        local tc1=g:GetFirst()
        local og=tc1:GetOverlayGroup()
        if og:GetCount()>0 then
            Duel.SendtoGrave(og,REASON_RULE)
        end
        Duel.Overlay(tc,Group.FromCards(tc1))
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47592582.splimit)
    Duel.RegisterEffect(e1,tp)
end
function c47592582.splimit(e,c)
    return not ((c:IsAttackAbove(2000) and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_LIGHT)) or (c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRank(8))) and c:IsLocation(LOCATION_EXTRA)
end
function c47592582.filter2(c)
    return c:IsType(TYPE_COUNTER) and c:IsAbleToHand()
end
function c47592582.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47592582.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c47592582.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47592582.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_MSET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(aux.TRUE)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_SSET)
    Duel.RegisterEffect(e2,tp)
    local e3=e1:Clone()
    e3:SetCode(EFFECT_CANNOT_TURN_SET)
    Duel.RegisterEffect(e3,tp)
    local e4=e1:Clone()
    e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e4:SetTarget(c47592582.sumlimit)
    Duel.RegisterEffect(e4,tp)
end
function c47592582.sumlimit(e,c,sump,sumtype,sumpos,targetp)
    return bit.band(sumpos,POS_FACEDOWN)>0
end