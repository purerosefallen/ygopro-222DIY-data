--水晶世界
function c81010004.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c81010004.sumsuc)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c81010004.atkcon)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81010004,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_FZONE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,81010004)
	e3:SetCost(c81010004.cost)
	e3:SetTarget(c81010004.target)
	e3:SetOperation(c81010004.activate)
	c:RegisterEffect(e3)
	--summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81010004,1))
	e4:SetCategory(CATEGORY_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,81010094)
	e4:SetTarget(c81010004.sumtg)
	e4:SetOperation(c81010004.sumop)
	c:RegisterEffect(e4)
end
function c81010004.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsAttribute(ATTRIBUTE_WIND)
end
function c81010004.atkcon(e)
	return Duel.IsExistingMatchingCard(c81010004.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,3,nil)
end
function c81010004.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TUNER) and c:IsAbleToDeckAsCost()
end
function c81010004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81010004.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c81010004.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c81010004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)
	if chk==0 then return ct>0 and (ct==1 or not Duel.IsPlayerAffectedByEffect(tp,59822133))
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>ct-2 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,0,0)
end
function c81010004.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local ct=Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)
	if ft<ct then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,81010005,0,0x4011,800,800,3,RACE_ROCK,ATTRIBUTE_WIND) then return end
	for i=1,ct do
		local token=Duel.CreateToken(tp,81010005)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1,true)
	end
	Duel.SpecialSummonComplete()
end
function c81010004.sumfilter(c)
	return c:IsSummonable(true,nil) and not c:IsType(TYPE_TUNER)
end
function c81010004.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81010004.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c81010004.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c81010004.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c81010004.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c81010004.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_WIND) and c:IsLocation(LOCATION_EXTRA)
end
function c81010004.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(81010004,2))
end 
