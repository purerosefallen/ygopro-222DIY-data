local m=77707007
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.dfc_front_side=m+7
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(cm.condition)
	e1:SetOperation(cm.operation1)
	c:RegisterEffect(e1)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler(),TYPE_MONSTER) end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler(),TYPE_MONSTER)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,aux.ExceptThisCard(e),TYPE_MONSTER)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
	end
end
function cm.check(g)
	return g:GetClassCount(Card.GetOrignalCode)==1
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()~=tp and chkc:IsControlerCanBeChanged() end
	local mg=Duel.IsExistingTarget(function(c)
		return c:IsCanBeEffectTarget(e) and c:IsControlerCanBeChanged()
	end,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return Duel.GetMZoneCount(tp,nil,tp,LOCATION_REASON_CONTROL)>1 and mg:CheckSubGroup(cm.check,2,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=mg:SelectSubGroup(tp,cm.check,false,2,2)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,2,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or not Duel.GetMZoneCount(tp,nil,tp,LOCATION_REASON_CONTROL)>1 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	for tc in aux.Next(g) do
		Duel.GetControl(tc,tp)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Senya.IsDFCTransformable(e:GetHandler()) and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD+LOCATION_HAND)<=2
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	Senya.TransformDFCCard(e:GetHandler())
end