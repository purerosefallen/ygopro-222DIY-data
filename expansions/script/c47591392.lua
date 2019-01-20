--紧急出击！
function c47591392.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,47591392)
    e1:SetTarget(c47591392.target)
    e1:SetOperation(c47591392.activate)
    c:RegisterEffect(e1)    
end
function c47591392.filter(c,e,tp)
    return ((c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_WARRIOR) and c:IsLevel(5)) or (c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_PSYCHO) and c:IsLevel(3)) or (c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_SPELLCASTER) and c:IsLevel(4))) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47591392.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCountFromEx(tp)>0 and Duel.IsExistingMatchingCard(c47591392.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c47591392.spfilter2(c,e,tp,mc)
    return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and aux.IsCodeListed(c,mc:GetCode())
end
function c47591392.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or Duel.GetLocationCountFromEx(tp)<1 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47591392.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g1=Duel.SelectMatchingCard(tp,c47591392.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
        local sc=g1:GetFirst()
        if sc then
            local mg=tc:GetOverlayGroup()
            if mg:GetCount()~=0 then
                Duel.Overlay(sc,mg)
            end
            sc:SetMaterial(Group.FromCards(tc))
            Duel.Overlay(sc,Group.FromCards(tc))
            Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
            sc:CompleteProcedure()
            if c:IsRelateToEffect(e) then
                c:CancelToGrave()
                Duel.Overlay(sc,Group.FromCards(c))
            end
        end
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47591392.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c47591392.splimit(e,c)
    return not c:IsRace(RACE_MACHINE) and c:IsLocation(LOCATION_EXTRA)
end