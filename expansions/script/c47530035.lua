--月神坦克
function c47530035.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)     
    --splimit
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e0:SetRange(LOCATION_PZONE)
    e0:SetTargetRange(1,0)
    e0:SetTarget(c47530035.splimit)
    c:RegisterEffect(e0)
    --reborn
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47530035,1))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_CHAINING)
    e4:SetRange(LOCATION_EXTRA)
    e4:SetCountLimit(1,47530036)
    e4:SetCondition(c47530035.hspcon)
    e4:SetTarget(c47530035.hsptg)
    e4:SetOperation(c47530035.hspop)
    c:RegisterEffect(e4) 
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47530035,0))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetRange(LOCATION_PZONE)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,47530035)
    e2:SetCondition(c47530035.spcon)
    e2:SetTarget(c47530035.sptg)
    e2:SetOperation(c47530035.spop)
    c:RegisterEffect(e2)
    --
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47530035,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c47530035.xyzcon)
    e3:SetTarget(c47530035.xyztg)
    e3:SetOperation(c47530035.xyzop)
    c:RegisterEffect(e3)
end
function c47530035.splimit(e,c)
    return not c:IsRace(RACE_MACHINE)
end
function c47530035.cfilter(c,tp)
    return c:IsFaceup() and c:IsControler(tp) and c:IsRace(RACE_MACHINE) and c:IsLocation(LOCATION_MZONE)
end
function c47530035.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c47530035.cfilter,1,nil,tp)
end
function c47530035.filter(c,e,tp,g)
    return c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,g)>0
end
function c47530035.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=eg:Filter(c47530035.cfilter,nil,tp)
    if chk==0 then return Duel.IsExistingMatchingCard(c47530035.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,g) end
    Duel.SetTargetCard(g)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),tp,LOCATION_MZONE)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c47530035.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local g=eg:Filter(c47530035.cfilter,nil,tp)
    g:AddCard(c)
    if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=Duel.SelectMatchingCard(tp,c47530035.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,g)
        local tc=sg:GetFirst()
        if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
        local c=e:GetHandler()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
        tc:RegisterEffect(e1) 
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_DISABLE)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
        tc:RegisterEffect(e3) 
        local e4=e3:Clone()
        e4:SetCode(EFFECT_DISABLE_EFFECT)
        tc:RegisterEffect(e4)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
        e2:SetValue(LOCATION_HAND)
        e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
        tc:RegisterEffect(e2)
        Duel.SpecialSummonComplete()
        end
    end
end
function c47530035.xyzfilter(c,tp)
    return c:IsFaceup() and c:IsControler(tp) and c:IsRace(RACE_MACHINE)
end
function c47530035.xyzcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c47530035.xyzfilter,1,nil,tp)
end
function c47530035.xyzfilter(c)
    return c:IsSpecialSummonable(SUMMON_TYPE_XYZ) and c:IsRace(RACE_MACHINE)
end
function c47530035.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47530035.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c47530035.xyzop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47530035.xyzfilter,tp,LOCATION_EXTRA,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummonRule(tp,tc,SUMMON_TYPE_XYZ)
    end
end
function c47530035.hspcon(e,tp,eg,ep,ev,re,r,rp)
    local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    return (bit.band(loc,LOCATION_HAND)~=0 or bit.band(loc,LOCATION_GRAVE)~=0) and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetOriginalRace()==RACE_MACHINE
end
function c47530035.hspfilter(c,e,tp)
    return c:IsRace(RACE_MACHINE) and c:IsLevel(10) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c47530035.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47530035.hspfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c47530035.hspop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47530035.hspfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if Duel.SendtoHand(c,nil,REASON_EFFECT) and tc then
        Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP) 
    end
end