--千❀华❀缭❀乱
function c22261107.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c22261107.condition)
	e1:SetTarget(c22261107.target)
	e1:SetOperation(c22261107.activate)
	c:RegisterEffect(e1)
	--act qp in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetRange(LOCATION_HAND)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetCondition(c22261107.con)
	e2:SetTarget(c22261107.eftg)
	c:RegisterEffect(e2)
end
function c22261107.confilter(c)
	return c:IsType(TYPE_TOKEN) and c:IsRace(RACE_PLANT)
end
function c22261107.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22261107.confilter,tp,LOCATION_MZONE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>=5
end
function c22261107.rmfilter(c,p)
	return Duel.IsPlayerCanRemove(p,c) and not c:IsType(TYPE_TOKEN)
end
function c22261107.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD+LOCATION_EXTRA)
	local ct=g:GetCount()-Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	if e:GetHandler():IsLocation(LOCATION_HAND) then ct=ct-1 end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(1-tp,30459350) and ct>0 and g:IsExists(c22261107.rmfilter,1,nil,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,ct,0,0)
end
function c22261107.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(1-tp,30459350) then return end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD+LOCATION_EXTRA)
	local ct=g:GetCount()-Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local sg=g:FilterSelect(1-tp,c22261107.rmfilter,ct,ct,nil,1-tp)
		Duel.Remove(sg,POS_FACEDOWN,REASON_RULE)
	end
end
function c22261107.confilter(c)
	return c:IsRace(RACE_PLANT) and c:IsFaceup()
end
function c22261107.con(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22261107.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>=10
end
function c22261107.eftg(e,c)
	return c==e:GetHandler()
end