--刺耳嚎叫
function c65071018.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCountLimit(1,65071018+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c65071018.condition)
	e1:SetTarget(c65071018.target)
	e1:SetOperation(c65071018.activate)
	c:RegisterEffect(e1)
end

function c65071018.condition(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsType(TYPE_MONSTER)
end

function c65071018.filter(c)
	return c:IsAbleToHand() and c:IsDefenseBelow(1500) and c:GetBaseDefense()>=0
end

function c65071018.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65071018.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c65071018.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,g:GetCount(),1-tp,0)
end
function c65071018.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c65071018.filter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local ct=Duel.SendtoHand(g,nil,REASON_EFFECT)
		if ct>0 then
			Duel.BreakEffect()
			local hg=Duel.SelectMatchingCard(1-tp,aux.TRUE,tp,0,LOCATION_HAND,ct,ct,nil)
			Duel.SendtoGrave(hg,REASON_EFFECT)
		end
	end
end
