--照样被吓个半死
function c81010031.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81010031)
	e1:SetTarget(c81010031.target)
	e1:SetOperation(c81010031.activate)
	c:RegisterEffect(e1)
end
function c81010031.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c81010031.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81010031.filter,tp,LOCATION_SZONE,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,nil) end
	local sg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_SZONE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c81010031.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c81010031.filter,tp,LOCATION_SZONE,0,1,1,e:GetHandler())
	local tc=g:GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		local sg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
