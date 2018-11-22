--苍空剑士 丽莎
function c47550008.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47550008.psplimit)
    c:RegisterEffect(e1)  
    --spsummon success
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47550008,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCountLimit(1,47551008)
    e2:SetCondition(c47550008.spcon)
    e2:SetTarget(c47550008.sptg)
    e2:SetOperation(c47550008.spop)
    c:RegisterEffect(e2) 
    --Search
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47550008,1))
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetCondition(c47550008.tfcon)
    e3:SetTarget(c47550008.tftg)
    e3:SetOperation(c47550008.tfop)
    c:RegisterEffect(e3)   
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TOHAND)
    e4:SetRange(LOCATION_PZONE)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetCountLimit(1,47550008)
    e4:SetCondition(c47550008.pspcon)
    e4:SetTarget(c47550008.psptg)
    e4:SetOperation(c47550008.pspop)
    c:RegisterEffect(e4)   
end
c47550008.card_code_list={47500000}
function c47550008.pefilter(c)
    return c:IsRace(RACE_WARRIOR) or c:IsSetCard(0x5da) or c:IsAttribute(ATTRIBUTE_WIND) or c:IsRace(RACE_SPELLCASTER)
end
function c47550008.psplimit(e,c,tp,sumtp,sumpos)
    return not c47550008.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47550008.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c47550008.spfilter(c,e,tp)
    return c:IsSetCard(0x5d0) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c47550008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47550008.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c47550008.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47550008.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
        local c=e:GetHandler()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1,true)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e2,true)
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_ADD_TYPE)
        e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e3:SetReset(RESET_EVENT+RESETS_REDIRECT)
        e3:SetValue(TYPE_TUNER)
        tc:RegisterEffect(e3,true)
        local e4=Effect.CreateEffect(c)
        e4:SetType(EFFECT_TYPE_SINGLE)
        e4:SetCode(EFFECT_CHANGE_LEVEL)
        e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e4:SetReset(RESET_EVENT+RESETS_REDIRECT)
        e4:SetValue(1)
        tc:RegisterEffect(e4,true)
        Duel.SpecialSummonComplete()
    end
end
function c47550008.tfcon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c47550008.tffilter(c)
    return aux.IsCodeListed(c,47500000) and not c:IsForbidden() and c:IsType(TYPE_PENDULUM)
end
function c47550008.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47550008.tffilter,tp,LOCATION_DECK,0,1,nil) end
end
function c47550008.tfop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47550008.tffilter,tp,LOCATION_DECK,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetCode(EFFECT_CHANGE_TYPE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
        e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetRange(LOCATION_SZONE)
        e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
        e2:SetCode(EFFECT_LINK_SPELL_KOISHI)
        e2:SetValue(LINK_MARKER_TOP)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
        tc:RegisterEffect(e2)
    end
end
function c47550008.pspcon(e,tp,eg,ep,ev,re,r,rp)
    local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
    local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
    if not tc1 or not tc2 or not (tc1:IsSetCard(0x5d0) or aux.IsCodeListed(tc1,47500000)) or not (tc2:IsSetCard(0x5d0) or aux.IsCodeListed(tc2,47500000)) then return false end
    local scl1=tc1:GetLeftScale()
    local scl2=tc2:GetRightScale()
    if scl1>scl2 then scl1,scl2=scl2,scl1 end
    return scl1==1 and scl2==13
end
function c47550008.filter(c)
    return (c:IsSetCard(0x5d0) or aux.IsCodeListed(c,47500000)) and c:IsType(TYPE_PENDULUM)
end
function c47550008.psptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_HAND) and chkc:IsControler(tp) and chkc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c47550008.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND)
end
function c47550008.pspop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47550008.filter,tp,LOCATION_HAND,0,ft,ft,nil,e,tp)
    if g:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
    if g:GetCount()>ft then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        g=g:Select(tp,ft,ft,nil)
    end
    for tc in aux.Next(g) do
        local bool=aux.PendulumSummonableBool(tc)
        Duel.SpecialSummonStep(tc,SUMMON_TYPE_PENDULUM,tp,tp,bool,bool,POS_FACEUP)
    end
    Duel.SpecialSummonComplete()
    for tc in aux.Next(g) do tc:CompleteProcedure() end
end