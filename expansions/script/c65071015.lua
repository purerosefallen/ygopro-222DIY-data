--泣婴
function c65071015.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,65071015+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c65071015.condition)
	e1:SetTarget(c65071015.target)
	e1:SetOperation(c65071015.operation)
	c:RegisterEffect(e1)
end
function c65071015.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c65071015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end

function c65071015.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(p,1)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	end
end