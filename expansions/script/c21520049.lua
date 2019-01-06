--灵子殖装的解放
function c21520049.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520049,0))
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,21520049+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c21520049.target)
	e1:SetOperation(c21520049.activate)
	c:RegisterEffect(e1)
end
function c21520049.filter(c)
	return c:GetEquipGroup():FilterCount(Card.IsSetCard,nil,0x494)>0
end
function c21520049.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520049.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c21520049.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,g:GetCount(),0,0)
end
function c21520049.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c21520049.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	local ct=0
	local ect=0
	while tc do
		ect=tc:GetEquipGroup():FilterCount(Card.IsSetCard,nil,0x494)
		tc:RegisterFlagEffect(21520049,RESET_PHASE+PHASE_END,0,1,ect)
		tc=g:GetNext()
	end
	Duel.Release(g,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	tc=og:GetFirst()
	while tc do
		if tc:GetReasonEffect()==e and tc:GetFlagEffect(21520049)~=0 then
			ct=ct+tc:GetFlagEffectLabel(21520049)
		end
		tc:ResetFlagEffect(21520049)
		tc=og:GetNext()
	end
	Duel.BreakEffect()
	if Duel.IsPlayerCanDraw(tp) and Duel.SelectYesNo(tp,aux.Stringid(21520049,1)) then 
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end

