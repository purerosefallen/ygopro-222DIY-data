--正义裁决者
function c65071062.initial_effect(c)
	--gain effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COIN+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c65071062.target)
	e1:SetOperation(c65071062.activate)
	c:RegisterEffect(e1)
end
c65071062.toss_coin=true
function c65071062.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local num=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,num)
end
function c65071062.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	local tc=g:GetFirst()
	while tc do
		local hg=Group.CreateGroup()
		hg:AddCard(tc)
		Duel.HintSelection(hg)
		local ct=Duel.TossCoin(tp,1)
		if ct==0 then Duel.SendtoGrave(tc,REASON_EFFECT) end
		tc=g:GetNext()
	end
end

