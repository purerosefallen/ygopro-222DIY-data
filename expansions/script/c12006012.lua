--从你的异色眼中映出的是
function c12006012.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,12006012+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c12006012.con)
	e1:SetOperation(c12006012.operation)
	c:RegisterEffect(e1)
 end
function c12006012.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x8fbd)
end
function c12006012.con(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>PHASE_MAIN1 and ph<PHASE_MAIN2
		and Duel.IsExistingMatchingCard(c12006012.filter,tp,LOCATION_MZONE,0,1,nil) 
end
function c12006012.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if sg:GetCount()>0 then
		Duel.ChangePosition(sg,POS_FACEUP_ATTACK,0,POS_FACEUP_ATTACK,0)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c12006012.aclimit)
	e2:SetReset(RESET_PHASE+PHASE_BATTLE)
	Duel.RegisterEffect(e2,tp)
end
function c12006012.chlimit(e,ep,tp)
	return tp==ep
end
function c12006012.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end