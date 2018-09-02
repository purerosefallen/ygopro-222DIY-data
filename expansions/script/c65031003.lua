--纷乱的悲恸律歌
function c65031003.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c65031003.condition)
	e1:SetTarget(c65031003.target)
	e1:SetOperation(c65031003.activate)
	c:RegisterEffect(e1)
end
function c65031003.cfilter(c)
	return not c:IsCode(65031002) 
end
function c65031003.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev) and ep~=tp and Duel.GetMatchingGroupCount(c65031003.cfilter,tp,LOCATION_MZONE,0,nil)==0 
end
function c65031003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and  Duel.IsPlayerCanSpecialSummonMonster(tp,65031002,0,0x4011,1500,1500,6,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP,tp) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c65031003.activate(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
		ec:CancelToGrave()
		if Duel.SendtoDeck(ec,nil,2,REASON_EFFECT)~=0 and ec:IsLocation(LOCATION_DECK+LOCATION_EXTRA) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,65031002,0,0x4011,1500,1500,6,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP,tp) then
			local token=Duel.CreateToken(tp,65031004)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) 
			--cannot summon
			local e1=Effect.CreateEffect(token)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetRange(LOCATION_MZONE)
			e1:SetTargetRange(1,0)
			e1:SetTarget(c65031003.splimit)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CANNOT_SUMMON)
			token:RegisterEffect(e2,true)
			--tohand
			local e3=Effect.CreateEffect(token)
			e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
			e3:SetType(EFFECT_TYPE_QUICK_O)
			e3:SetCode(EVENT_CHAINING)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCountLimit(1)
			e3:SetCondition(c65031003.thcon)
			e3:SetTarget(c65031003.thtg)
			e3:SetOperation(c65031003.thop)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e3,true)
			--effect type
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_ADD_TYPE)
			e4:SetValue(TYPE_EFFECT)
			e4:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e4,true)
			token:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65031003,0))
			Duel.SpecialSummonComplete()
		end
	end
end
function c65031003.splimit(e,c)
	return not c:IsCode(65031002)
end

function c65031003.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp 
end
function c65031003.thfilter(c,tp)
	return c:IsSetCard(0xada1) and c:IsType(TYPE_COUNTER)
		and c:IsAbleToHand()
end
function c65031003.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65031003.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c65031003.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65031003.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
