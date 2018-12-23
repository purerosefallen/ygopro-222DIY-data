--月姬武圆舞
function c75646507.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c75646507.cost)
	e1:SetTarget(c75646507.target)
	e1:SetOperation(c75646507.activate)
	c:RegisterEffect(e1)
end
function c75646507.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x2c1)
	if chk==0 then return ct>0 end
	Duel.RemoveCounter(tp,LOCATION_ONFIELD,0,0x2c1,ct,REASON_COST)
	e:SetLabel(ct)
end
function c75646507.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	if e:GetLabel()>4 then
		e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	end
end
function c75646507.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,e:GetLabel(),nil)
		Duel.HintSelection(sg)
		local dc=sg:GetFirst()
		while dc do
			local ds=Duel.Destroy(dc,REASON_EFFECT)
			if e:GetLabel()>4 and ds==0 then
			Duel.SendtoGrave(dc,REASON_RULE) end  
			dc=sg:GetNext()
		end
	end
end