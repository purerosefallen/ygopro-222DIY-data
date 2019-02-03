--虚拟主播 电波酱 Hyper
function c81006014.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,81006014)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(c81006014.descon)
	e1:SetCost(c81006014.descost)
	e1:SetTarget(c81006014.destg)
	e1:SetOperation(c81006014.desop)
	c:RegisterEffect(e1)
	--cannot activate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(c81006014.aclimit)
	c:RegisterEffect(e4)
	--cannot activate
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(1,0)
	e5:SetValue(c81006014.bclimit)
	c:RegisterEffect(e5)
end
function c81006014.cfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c81006014.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81006014.cfilter,tp,LOCATION_GRAVE,0,7,nil)
end
function c81006014.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c81006014.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	if chk==0 then return cg:GetCount()>1 and cg:GetClassCount(Card.GetCode)==cg:GetCount() end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c81006014.desop(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if g:GetCount()>0 and cg:GetCount()>1 and cg:GetClassCount(Card.GetCode)==cg:GetCount() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
function c81006014.acfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c81006014.aclimit(e,re,tp)
	return Duel.IsExistingMatchingCard(c81006014.acfilter,e:GetHandlerPlayer(),0,LOCATION_REMOVED,1,nil,re:GetHandler():GetCode())
		and not re:GetHandler():IsImmuneToEffect(e)
end
function c81006014.bcfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c81006014.bclimit(e,re,tp)
	return Duel.IsExistingMatchingCard(c81006014.bcfilter,e:GetHandlerPlayer(),LOCATION_REMOVED,0,1,nil,re:GetHandler():GetCode())
		and not re:GetHandler():IsImmuneToEffect(e)
end
