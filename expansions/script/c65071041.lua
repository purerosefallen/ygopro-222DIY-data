--粉碎机MK4
function c65071041.initial_effect(c)
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c65071041.condition)
	e1:SetCost(c65071041.cost)
	e1:SetOperation(c65071041.activate)
	c:RegisterEffect(e1)
end
function c65071041.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c65071041.bkfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,rc)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end

function c65071041.bkfil(c)
	return not c:IsCode(65071041)
end

function c65071041.condition(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return Duel.GetMatchingGroupCount(c65071041.bkfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,rc)~=0
end
function c65071041.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c65071041.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c65071041.repop)
end