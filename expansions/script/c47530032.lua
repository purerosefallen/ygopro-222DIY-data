--高达EZ8
function c47530032.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47530032,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,47530032)
    e1:SetTarget(c47530032.sptg)
    e1:SetOperation(c47530032.spop)
    c:RegisterEffect(e1)
    --
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47530032,1))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1,47530033)
    e2:SetCost(c47530032.thcost)
    e2:SetTarget(c47530032.thtg)
    e2:SetOperation(c47530032.thop)
    c:RegisterEffect(e2)
    --
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47530032,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c47530032.xyzcon)
    e3:SetTarget(c47530032.xyztg)
    e3:SetOperation(c47530032.xyzop)
    c:RegisterEffect(e3)
end
function c47530032.spfilter(c,e,tp)
    return c:IsRace(RACE_MACHINE) and c:IsLevel(10) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47530032.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47530032.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c47530032.spop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c47530032.spfilter),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
        local c=e:GetHandler()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
        tc:RegisterEffect(e1)
        Duel.SpecialSummonComplete()
    end
end
function c47530032.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDiscardable() end
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c47530032.thfilter(c)
    return c:IsRace(RACE_MACHINE) and c:IsAbleToHand() and not c:IsCode(47530032)
end
function c47530032.spfilter1(c,e,tp)
    return c:IsRace(RACE_MACHINE) and c:IsLevel(10) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47530032.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c47530032.thfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c47530032.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c47530032.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c47530032.thop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local g1=Duel.GetMatchingGroup(c47530032.spfilter1,tp,LOCATION_HAND,0,nil,e,tp)
    local sg=g:Filter(Card.IsRelateToEffect,nil,e)
    if sg:GetCount()>0 then
        if Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 and #g1>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(47530032,3)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg1=g1:Select(tp,1,1,nil)
        Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
        end
    end
end
function c47530032.xyzfilter(c,tp)
    return c:IsFaceup() and c:IsControler(tp) and c:IsRace(RACE_MACHINE)
end
function c47530032.xyzcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c47530032.xyzfilter,1,nil,tp)
end
function c47530032.filter(c)
    return c:IsSpecialSummonable(SUMMON_TYPE_LINK) and c:IsRace(RACE_MACHINE)
end
function c47530032.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47530032.filter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c47530032.xyzop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47530032.filter,tp,LOCATION_EXTRA,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummonRule(tp,tc,SUMMON_TYPE_LINK)
    end
end