--天命的灵刻使
local m=10904027
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(98850929,4))
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(cm.condition)
    e1:SetCost(cm.cost)
    e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.operation)
    c:RegisterEffect(e1)    
end
function cm.cfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_FUSION+TYPE_LINK+TYPE_SYNCHRO+TYPE_XYZ)
end
function cm.typecast(c)
    return bit.band(c:GetType(),TYPE_FUSION+TYPE_LINK+TYPE_SYNCHRO+TYPE_XYZ)
end
function cm.csfilter(c)
    return c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost() and c:IsSetCard(0x237)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil)
    local ct=g:GetClassCount(cm.typecast)
    if chk==0 then return 
	(ct<=2 and Duel.IsExistingMatchingCard(cm.csfilter,tp,LOCATION_HAND,0,1,e:GetHandler()))
	or (ct>=3 and Duel.IsExistingMatchingCard(cm.csfilter,tp,LOCATION_DECK,0,1,nil)) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	if ct<=2 then
    local g1=Duel.SelectMatchingCard(tp,cm.csfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g1,REASON_COST)
	else
    local g2=Duel.SelectMatchingCard(tp,cm.csfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g2,REASON_COST) end
end
function cm.filter2(c)
    return c:IsFaceup() and not c:IsSetCard(0x237)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) and not Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_MZONE,0,1,nil)
end
function cm.filter(c)
    return c:IsSetCard(0x237) and c:IsType(TYPE_SPELL) and c:CheckActivateEffect(true,true,false)~=nil and not (c:IsCode(m) or c:IsType(TYPE_CONTINUOUS))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local tp=e:GetHandler():GetControler()
    local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
    local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
    if chkc then
        local te=e:GetLabelObject()
        local tg=te:GetTarget()
        return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
    end
    if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil) end
    e:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e:SetCategory(0)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil)
    local te=g:GetFirst():CheckActivateEffect(true,true,false)
    Duel.ClearTargetCard()
    e:SetCategory(te:GetCategory())
    e:SetProperty(te:GetProperty())
    e:SetLabel(te:GetLabel())
    e:SetLabelObject(te:GetLabelObject())
    local tg=te:GetTarget()
    if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
    te:SetLabel(e:GetLabel())
    te:SetLabelObject(e:GetLabelObject())
    e:SetLabelObject(te)
	if not tc1 or not tc2 then return end
	if not tc1:GetLeftScale()==tc2:GetRightScale() then return end
    e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local te=e:GetLabelObject()
    if te:GetHandler():IsRelateToEffect(e) then
        e:SetLabel(te:GetLabel())
        e:SetLabelObject(te:GetLabelObject())
        local op=te:GetOperation()
        if op then op(e,tp,eg,ep,ev,re,r,rp) end
        te:SetLabel(e:GetLabel())
        te:SetLabelObject(e:GetLabelObject())
    end
end
