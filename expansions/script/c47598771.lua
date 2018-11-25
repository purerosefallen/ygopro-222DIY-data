--淳朴的圣少女 贞德
function c47598771.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47598771.psplimit)
    c:RegisterEffect(e1) 
    --pendulum SpecialSummon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCondition(c47598771.pencon)
    e2:SetCost(c47598771.cost)
    e2:SetTarget(c47598771.pentg)
    e2:SetOperation(c47598771.penop)
    c:RegisterEffect(e2)     
end
function c47598771.pefilter(c)
    return c:IsRace(RACE_FAIRY) or c:IsRace(RACE_SPELLCASTER) or c:IsRace(RACE_WARRIOR)
end
function c47598771.psplimit(e,c,tp,sumtp,sumpos)
    return not c47598771.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47598771.cfilter(c)
    return c:IsSetCard(0x5d0)
end
function c47598771.pencon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c47598771.cfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c47598771.costfilter(c)
    return c:IsReleasable()
end
function c47598771.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(c47598771.costfilter,tp,LOCATION_PZONE,0,nil)
    if chk==0 then return #g>=2 end
    Duel.Release(g,REASON_COST)
end
function c47598771.penfilter(c)
    return c:IsSetCard(0x5d0) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c47598771.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDestructable()
        and Duel.IsExistingMatchingCard(c47598771.penfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_RELEASE,e:GetHandler(),1,0,0)
end
function c47598771.penop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local g=Duel.SelectMatchingCard(tp,c47598771.penfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end