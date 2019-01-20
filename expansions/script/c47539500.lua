--里歇尔
function c47539500.initial_effect(c)
    --link summon
    aux.AddSynchroMixProcedure(c,c47539500.matfilter1,nil,nil,aux.NonTuner(Card.IsAttribute,ATTRIBUTE_WIND),1,99)
    c:EnableReviveLimit()    
    --search
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47539500,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,47539500)
    e1:SetCondition(c47539500.spcon)
    e1:SetTarget(c47539500.sptg)
    e1:SetOperation(c47539500.spop)
    c:RegisterEffect(e1)
    --atk
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47539500,1))
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,47539501)
    e2:SetCondition(c47539500.atkcon)
    e2:SetCost(c47539500.atkcost)
    e2:SetTarget(c47539500.atktg)
    e2:SetOperation(c47539500.atkop)
    c:RegisterEffect(e2)
end
function c47539500.matfilter1(c)
    return c:IsSynchroType(TYPE_TUNER) or c:IsRace(RACE_MACHINE)
end
function c47539500.lcheck(g,lc)
    return g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WIND)
end
function c47539500.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c47539500.thfilter1(c,g)
    return g:IsExists(c47539500.thfilter2,1,c,c)
end
function c47539500.thfilter2(c,mc)
    return not c:IsCode(mc:GetCode()) and c:GetLevel()+mc:GetLevel()==7  and c:IsType(TYPE_TUNER)
end
function c47539500.thfilter(c)
    return c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c47539500.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)  and Duel.IsExistingMatchingCard(c47539500.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,g) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c47539500.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
    local g=Duel.GetMatchingGroup(c47539500.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local sg=g:FilterSelect(tp,c47539500.thfilter1,1,1,nil,g)
    if #sg>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg2=g:FilterSelect(tp,c47539500.thfilter2,1,1,sg:GetFirst(),sg:GetFirst())
        if sg:Merge(sg2)~=0 then
            Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE) 
        end
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47539500.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c47539500.splimit(e,c)
    return not c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_EXTRA)
end
function c47539500.cfilter(c)
    return c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_WIND) and not c:IsCode(47539500)
end
function c47539500.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c47539500.cfilter,1,nil,tp)
end
function c47539500.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    e:SetLabel(1)
    return true
end
function c47539500.atkfilter(c)
    return c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_MACHINE) and (c:GetBaseAttack()>0 or c:GetBaseDefense()>0) and c:IsAbleToGraveAsCost()
end
function c47539500.tgfilter(c,tp,eg)
    return eg:IsContains(c)
end
function c47539500.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        if e:GetLabel()~=1 then return false end
        e:SetLabel(0)
        return Duel.IsExistingMatchingCard(c47539500.atkfilter,tp,LOCATION_DECK,0,1,nil)
    end
    e:SetLabel(0)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c47539500.atkfilter,tp,LOCATION_DECK,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
    e:SetLabelObject(g:GetFirst())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c47539500.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,eg)
end
function c47539500.atkop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local sc=e:GetLabelObject()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) and sc then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
        local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
        local nseq=math.log(s,2)
        Duel.MoveSequence(tc,nseq)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(sc:GetAttack())
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        e2:SetValue(sc:GetDefense())
        tc:RegisterEffect(e2)
    end
end