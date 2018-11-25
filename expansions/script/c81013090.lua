--Wings·三峰结华
function c81013090.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,2)
	c:EnableReviveLimit()
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(81013000)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81013090)
	e2:SetCondition(c81013090.cfcon)
	e2:SetCost(c81013090.cfcost)
	e2:SetTarget(c81013090.cftg)
	e2:SetOperation(c81013090.cfop)
	c:RegisterEffect(e2)
end
function c81013090.cfcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	return (a:IsControler(tp) and a~=e:GetHandler() and a:IsSetCard(0x811))
		or (at and at:IsControler(tp) and at:IsFaceup() and at~=e:GetHandler() and at:IsSetCard(0x811))
end
function c81013090.cfcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c81013090.cftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c81013090.cffilter(c)
	return c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c81013090.cfop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()==0 then return end
	Duel.ConfirmCards(tp,g)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		local sg=g:Filter(c81013090.cffilter,nil)
		if sg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local setg=sg:Select(tp,1,1,nil)
			Duel.SSet(tp,setg:GetFirst())
			Duel.ConfirmCards(1-tp,setg)
		end
	end
	Duel.ShuffleHand(1-tp)
end