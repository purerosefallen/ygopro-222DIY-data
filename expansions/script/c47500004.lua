--忍者 姬塔
function c47500004.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --code
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_CHANGE_CODE)
    e2:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA)
    e2:SetValue(47500000)
    c:RegisterEffect(e2)
    --sps
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47500004,0))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetRange(LOCATION_HAND)
    e3:SetCountLimit(1,47500005)
    e3:SetCondition(c47500004.spcon)
    e3:SetTarget(c47500004.sptg)
    e3:SetOperation(c47500004.spop)
    c:RegisterEffect(e3) 
    local e4=e3:Clone()
    e4:SetRange(LOCATION_PZONE)
    e4:SetCountLimit(1,47500114+EFFECT_COUNT_CODE_OATH)
    e4:SetOperation(c47500004.spop2)
    c:RegisterEffect(e4)
end
c47500004.card_code_list={47500000}
function c47500004.spcfilter(c,tp)
    return c:IsReason(REASON_BATTLE+REASON_EFFECT)
        and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousCodeOnField()==47500000
end
function c47500004.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c47500004.spcfilter,1,nil,tp)
end
function c47500004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c47500004.desfilter(c,tp,id)
    return c:IsType(TYPE_PENDULUM)
end
function c47500004.tffilter(c)
    return aux.IsCodeListed(c,47500000) and c:IsType(TYPE_PENDULUM)
end
function c47500004.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
        local g=Duel.GetMatchingGroup(c47500004.desfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil,tp)
        if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(47500004,1)) then
            Duel.BreakEffect()
            local g=Duel.SelectMatchingCard(tp,c47500004.desfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
            if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT) then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
                local sg=Duel.SelectMatchingCard(tp,c47500004.tffilter,tp,LOCATION_EXTRA,0,1,1,nil)
                local tc=sg:GetFirst()
                if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)~=0 then
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
                e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
                e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
                e1:SetValue(LOCATION_DECK)
                tc:RegisterEffect(e1)
                end
            end
        end
    end
end
function c47500004.spop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
        local sg=Duel.SelectMatchingCard(tp,c47500004.tffilter,tp,LOCATION_DECK,0,1,1,nil)
        local tc=sg:GetFirst()
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)    
    end
end