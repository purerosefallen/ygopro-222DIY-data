--武装神姬 月下天使
local m=14801124
local cm=_G["c"..m]
function cm.initial_effect(c)
    --equip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(cm.spcon)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.operation)
    c:RegisterEffect(e1)
end
function cm.cfilter(c)
    return c:IsFaceup() and c:IsCode(14801101)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.efilter(c)
    return c:IsFaceup() and c:IsSetCard(0x4811)
end
function cm.eqfilter(c,g)
    return c:IsSetCard(0x4811) and c:IsType(TYPE_MONSTER) and g:IsExists(cm.eqcheck,1,nil,c)
end
function cm.eqcheck(c,ed)
    return ed:CheckEquipTarget(c)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
        local g=Duel.GetMatchingGroup(cm.efilter,tp,LOCATION_MZONE,0,nil)
        return Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_GRAVE,0,1,nil,g)
    end
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
    if ft<=0 then return end
    local g=Duel.GetMatchingGroup(cm.efilter,tp,LOCATION_MZONE,0,nil)
    local eq=Duel.GetMatchingGroup(cm.eqfilter,tp,LOCATION_GRAVE,0,nil,g)
    if ft>eq:GetCount() then ft=eq:GetCount() end
    if ft==0 then return end
    for i=1,ft do
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
        local ec=eq:Select(tp,1,1,nil):GetFirst()
        eq:RemoveCard(ec)
        local td=g:FilterSelect(tp,cm.eqcheck,1,1,nil,ec):GetFirst()
        Duel.Equip(tp,ec,td,true,true)
    end
    Duel.EquipComplete()
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CHANGE_DAMAGE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,1)
    e1:SetValue(0)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end