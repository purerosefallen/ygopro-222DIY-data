--白之女帝·Lucifuge Rophocale
function c9980194.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),8,3,c9980194.ovfilter,aux.Stringid(9980194,0),3,c9980194.xyzop)
	--disable search
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_TO_HAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK+LOCATION_GRAVE))
	c:RegisterEffect(e3)
	--token
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9980194,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,9980194)
	e4:SetCost(c9980194.spcost)
	e4:SetOperation(c9980194.spop)
	c:RegisterEffect(e4)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,99801940)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCondition(c9980194.negcon)
	e2:SetOperation(c9980194.negop)
	c:RegisterEffect(e2)
end
function c9980194.cfilter(c)
	return (c:IsSetCard(0x95) or c:IsSetCard(0x2bc8))and c:IsDiscardable()
end
function c9980194.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2bc8) and c:IsType(TYPE_LINK)
end
function c9980194.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9980194.cfilter,tp,LOCATION_HAND,0,2,nil) end
	Duel.DiscardHand(tp,c9980194.cfilter,2,2,REASON_COST+REASON_DISCARD)
end
function c9980194.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9980194.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),2)
	if ft>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,9980195,0x2bc8,0x4011,1300,1300,4,RACE_FAIRY,ATTRIBUTE_DARK) then 
	Duel.BreakEffect()
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		repeat
			local token=Duel.CreateToken(tp,9980195)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		token:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
		ft=ft-1
		until ft==0 or not Duel.SelectYesNo(tp,210)
	end
end
function c9980194.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c9980194.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateEffect(ev) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE)
		c:RegisterEffect(e1)
	end
end