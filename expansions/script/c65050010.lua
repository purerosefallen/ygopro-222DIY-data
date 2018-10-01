--唤灵终形 瑟
function c65050010.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.ritlimit)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1)
	e1:SetCondition(c65050010.condition)
	e1:SetCost(c65050010.cost)
	e1:SetTarget(c65050010.target)
	e1:SetOperation(c65050010.activate)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCountLimit(1,65050010)
	e2:SetTarget(c65050010.sptg)
	e2:SetOperation(c65050010.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_LEAVE_FIELD)
	c:RegisterEffect(e3)
end
function c65050010.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and ep~=tp
end
function c65050010.cocofil(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3da1) and c:IsReleasable()
end

function c65050010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050010.cocofil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	local sg=Duel.SelectMatchingCard(tp,c65050010.cocofil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=sg:GetFirst()
	e:SetLabel(tc:GetAttack())
	Duel.Release(sg,REASON_COST)
end
function c65050010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c65050010.activate(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
		ec:CancelToGrave()
		Duel.SendtoDeck(ec,nil,2,REASON_EFFECT)
	end
end

function c65050010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,65050012,0,0x4011,0,0,6,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c65050010.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,65050012,0,0x4011,0,0,6,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,65050012)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(10)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e1)
	if Duel.SpecialSummonComplete()~=0 then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,3,nil)
		if g:GetCount()>0 then
			Duel.SendtoDeck(g,tp,2,REASON_EFFECT)
			Duel.ShuffleDeck(tp)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end