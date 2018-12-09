--姬塔
local m=47500000
local cm=_G["c"..m]
function c47500000.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47500000.psplimit)
    c:RegisterEffect(e1)   
    --pendulum SpecialSummon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCondition(c47500000.pencon)
    e2:SetCost(c47500000.cost)
    e2:SetTarget(c47500000.pentg)
    e2:SetOperation(c47500000.penop)
    c:RegisterEffect(e2)  
end
c47500000.card_code_list={47500000}
function c47500000.pefilter(c)
    return (aux.IsCodeListed(c,47500000) or c:IsCode(47500000)) or c:IsSetCard(0x5d0)
end
function c47500000.psplimit(e,c,tp,sumtp,sumpos)
    return not c47500000.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47500000.cfilter(c)
    return c:IsCode(47500000)
end
function c47500000.pencon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c47500000.cfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c47500000.costfilter(c)
    return c:IsReleasable()
end
function c47500000.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(c47500000.costfilter,tp,LOCATION_PZONE,0,nil)
    if chk==0 then return #g>=2 end
    Duel.Release(g,REASON_COST)
end
function c47500000.penfilter(c)
    return aux.IsCodeListed(c,47500000) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c47500000.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDestructable()
        and Duel.IsExistingMatchingCard(c47500000.penfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_RELEASE,e:GetHandler(),1,0,0)
end
function c47500000.penop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local g=Duel.SelectMatchingCard(tp,c47500000.penfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end