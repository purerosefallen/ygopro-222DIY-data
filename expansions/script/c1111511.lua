--交界·星梦冢
local m=1111511
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Border=true
--
function c1111511.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1111511+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c1111511.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(c1111511.tg2)
	e2:SetValue(c1111511.val2)
	c:RegisterEffect(e2)
--
end
--
function c1111511.ofilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_SPIRIT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1111511.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return end
	if not Duel.IsExistingMatchingCard(c1111511.ofilter1,tp,LOCATION_GRAVE,0,1,nil) then return end
	if Duel.SelectYesNo(tp,aux.Stringid(1111511,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c1111511.ofilter1,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()<=0 then return end
		local tc=g:GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		if tc:IsCanAddCounter(0x1111,1) then tc:AddCounter(0x1111,1) end
	end
end
--
function c1111511.tfilter2(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE) and c:GetDestination()==LOCATION_DECK and c:IsAbleToHand()
end
function c1111511.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bit.band(r,REASON_EFFECT)~=0 and re and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsType(TYPE_SPIRIT) and re:GetHandler():IsRace(RACE_PSYCHO) and eg:IsExists(c1111511.tfilter2,1,nil,tp) end
	if Duel.SelectYesNo(tp,aux.Stringid(1111511,1)) then
		local g=eg:Filter(c1111511.tfilter2,nil,tp)
		local ct=g:GetCount()
		if ct>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			g=g:Select(tp,1,ct,nil)
		end
		local tc=g:GetFirst()
		while tc do
			local e2_1=Effect.CreateEffect(e:GetHandler())
			e2_1:SetType(EFFECT_TYPE_SINGLE)
			e2_1:SetCode(EFFECT_TO_DECK_REDIRECT)
			e2_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2_1:SetValue(LOCATION_HAND)
			e2_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2_1)
			tc:RegisterFlagEffect(1111511,RESET_EVENT+0x1de0000+RESET_PHASE+PHASE_END,0,1)
			tc=g:GetNext()
		end
		local e2_2=Effect.CreateEffect(e:GetHandler())
		e2_2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2_2:SetCode(EVENT_TO_HAND)
		e2_2:SetCountLimit(1)
		e2_2:SetCondition(c1111511.con2_2)
		e2_2:SetOperation(c1111511.op2_2)
		e2_2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2_2,tp)
		return true
		else return false 
	end
end
--
function c1111511.cfilter2_2(c)
	return c:GetFlagEffect(1111511)~=0
end
function c1111511.con2_2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1111511.cfilter2_2,1,nil)
end
function c1111511.op2_2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c1111511.cfilter2_2,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
--
function c1111511.val2(e,c)
	return false
end
--
