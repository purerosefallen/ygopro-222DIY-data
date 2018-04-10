--灵都·幻想天地
local m=1111502
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Urban=true
--
function c1111502.initial_effect(c)
--
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1111502,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,1111502)
	e1:SetCondition(c1111502.con1)
	e1:SetCost(c1111502.cost1)
	e1:SetTarget(c1111502.tg1)
	e1:SetOperation(c1111502.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1111502,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCost(c1111502.cost2)
	e2:SetTarget(c1111502.tg2)
	e2:SetOperation(c1111502.op2)
	c:RegisterEffect(e2)
--
end
--
function c1111502.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,nil)
end
--
function c1111502.cfilter1(c)
	return c:GetType()==TYPE_SPELL and c:IsDiscardable()
end
function c1111502.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c1111502.cfilter1,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local sg=Duel.SelectMatchingCard(tp,c1111502.cfilter1,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(sg,REASON_COST+REASON_DISCARD)
end
--
function c1111502.tfilter1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and muxu.check_set_Urban(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetLevel()==3
end
function c1111502.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c1111502.tfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
--
function c1111502.ofilter1(c)
	return muxu.check_set_Urban(c) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and not c:IsForbidden()
end
function c1111502.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c1111502.tfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if sg:GetCount()<1 then return end
	if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c1111502.ofilter1,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(1111502,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1111502,2))
		local tg=Duel.SelectMatchingCard(tp,c1111502.ofilter1,tp,LOCATION_DECK,0,1,1,nil)
		if tg:GetCount()<1 then return end
		local tc=tg:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1_1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1_1)
	end
end
--
function c1111502.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
--
function c1111502.tfilter2(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_FIELD)
end
function c1111502.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c1111502.tfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c1111502.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c1111502.tfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if sg:GetCount()<1 then return end
	local sc=sg:GetFirst()
	if Duel.SendtoHand(sg,nil,REASON_EFFECT)<1 then return end
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_SINGLE)
	e2_1:SetCode(EFFECT_PUBLIC)
	e2_1:SetReset(RESET_EVENT+0x1fe0000)
	sc:RegisterEffect(e2_1)
	sc:RegisterFlagEffect(1111502,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,66)
	local code=sc:GetCode()
	local e2_2=Effect.CreateEffect(c)
	e2_2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2_2:SetType(EFFECT_TYPE_FIELD)
	e2_2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2_2:SetTargetRange(1,0)
	e2_2:SetValue(c1111502.val2_2)
	e2_2:SetLabelObject(code)
	e2_2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2_2,tp)
end
--
function c1111502.val2_2(e,te,tp)
	local tc=te:GetHandler()
	local code=e:GetLabelObject()
	return te:IsHasType(EFFECT_TYPE_ACTIVATE) and tc:IsCode(code)
end
--
