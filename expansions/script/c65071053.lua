--余香
function c65071053.initial_effect(c)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,65071053+EFFECT_COUNT_CODE_OATH)
	e3:SetTarget(c65071053.target)
	e3:SetOperation(c65071053.activate3)
	c:RegisterEffect(e3)
end
function c65071053.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function c65071053.activate3(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 then
		local c=e:GetHandler()
		local g=Duel.GetOperatedGroup()
		local tc=g:GetFirst()
		Duel.ConfirmCards(tp,tc)
		if tc:IsType(TYPE_MONSTER) then
			Duel.BreakEffect()
			local dg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
			local dg2=dg:Filter(Card.IsRace,nil,tc:GetRace())
			local dg3=dg:Filter(Card.IsAttribute,nil,tc:GetAttribute())
			dg2:Merge(dg3)
			Duel.Destroy(dg2,REASON_EFFECT)
		end
		Duel.ShuffleHand(1-tp)
	end
end
