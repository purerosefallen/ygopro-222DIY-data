--甜蜜的美梦律歌
function c65031011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c65031011.condition)
	e1:SetTarget(c65031011.target)
	e1:SetOperation(c65031011.activate)
	c:RegisterEffect(e1)
end
function c65031011.cfilter(c)
	return not c:IsCode(65031002) 
end
function c65031011.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasCategory(CATEGORY_SUMMON+CATEGORY_SPECIAL_SUMMON) and Duel.IsChainNegatable(ev) and ep~=tp and Duel.GetMatchingGroupCount(c65031011.cfilter,tp,LOCATION_MZONE,0,nil)==0 
end
function c65031011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,65031002,0,0x4011,1500,1500,6,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP,tp) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c65031011.activate(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
		ec:CancelToGrave()
		if Duel.SendtoDeck(ec,nil,2,REASON_EFFECT)~=0 and ec:IsLocation(LOCATION_DECK+LOCATION_EXTRA) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,65031002,0,0x4011,1500,1500,6,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP,tp) then
			local token=Duel.CreateToken(tp,65031012)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) 
			--cannot summon
			local e1=Effect.CreateEffect(token)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetRange(LOCATION_MZONE)
			e1:SetTargetRange(1,0)
			e1:SetTarget(c65031011.splimit)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CANNOT_SUMMON)
			token:RegisterEffect(e2,true)
			--set
			local e3=Effect.CreateEffect(token)
			e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TODECK)
			e3:SetType(EFFECT_TYPE_QUICK_O)
			e3:SetCode(EVENT_SUMMON)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCondition(c65031011.discon)
			e3:SetCost(c65031011.discost)
			e3:SetTarget(c65031011.distg)
			e3:SetOperation(c65031011.disop)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e3,true)
			local e4=e3:Clone()
			e4:SetCode(EVENT_FLIP_SUMMON)
			token:RegisterEffect(e4)
			local e5=e3:Clone()
			e5:SetCode(EVENT_SPSUMMON)
			token:RegisterEffect(e5)
			--effect type
			local e6=Effect.CreateEffect(e:GetHandler())
			e6:SetType(EFFECT_TYPE_SINGLE)
			e6:SetCode(EFFECT_ADD_TYPE)
			e6:SetValue(TYPE_EFFECT)
			e6:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e6,true)
			token:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65031011,0))
			Duel.SpecialSummonComplete()
		end
	end
end
function c65031011.splimit(e,c)
	return not c:IsCode(65031002)
end

function c65031011.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and ep~=tp 
end
function c65031011.costfil(c)
	return c:IsSetCard(0xada1) and (c:IsFacedown() or c:IsLocation(LOCATION_HAND))  and c:IsAbleToRemoveAsCost()
end
function c65031011.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() and Duel.IsExistingMatchingCard(c65031011.costfil,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil) end
	Duel.Release(e:GetHandler(),REASON_COST)
	local g=Duel.SelectMatchingCard(tp,c65031011.costfil,tp,LOCATION_HAND+LOCATION_SZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c65031011.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,eg,eg:GetCount(),0,0)
end
function c65031011.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)
end
