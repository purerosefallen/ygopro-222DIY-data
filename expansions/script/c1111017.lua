--秘谈·投映的神秘
local m=1111017
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Legend=true
--
function c1111017.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c1111017.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,1111017)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c1111017.tg2)
	e2:SetOperation(c1111017.op2)
	c:RegisterEffect(e2)
--
end
--
function c1111017.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1_1:SetCode(EVENT_CHAINING)
	e1_1:SetCondition(c1111017.con1_1)
	e1_1:SetOperation(c1111017.op1_1)
	e1_1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1_1,tp)
	local e1_2=Effect.CreateEffect(c)
	e1_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1_2:SetCode(EVENT_CHAIN_SOLVED)
	e1_2:SetOperation(c1111017.op1_2)
	e1_2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1_2,tp)
end
--
function c1111017.con1_1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return muxu.check_set_Legend(rc) and rc:IsControler(tp) and not rc:IsCode(1111017)
end
--
function c1111017.op1_1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not rc:IsRelateToEffect(re) then return end
	rc:RegisterFlagEffect(1111017,RESET_EVENT+0x1fe0000,0,0)
end
--
function c1111017.ofilter1_2(c,tp)
	return c:GetFlagEffect(1111017)>0 and c:IsLocation(LOCATION_SZONE) and c:IsControler(tp) and c:IsStatus(STATUS_LEAVE_CONFIRMED)
end
function c1111017.op1_2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local sg=Duel.GetMatchingGroup(c1111017.ofilter1_2,tp,LOCATION_SZONE,0,nil,tp)
	if sg:GetCount()<=0 then return end
	local gn=Group.CreateGroup()
	local sc=sg:GetFirst()
	while sc do
		Duel.ResetFlagEffect(sc,1111017)
		if Duel.IsPlayerCanSpecialSummonMonster(tp,sc:GetCode(),nil,0x221,0,0,3,RACE_PSYCHO,ATTRIBUTE_LIGHT,POS_FACEUP) then 
			gn:AddCard(sc) 
		end
		sc=sg:GetNext()
	end
	local num=gn:GetCount()
	if num<=0 then return end
	if ft<num then num=ft end
	Duel.Hint(HINT_CARD,0,1111017)
	if Duel.SelectYesNo(tp,aux.Stringid(1111017,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=gn:Select(tp,1,num,nil)
		local tc=tg:GetFirst()
		while tc do
			tc:AddMonsterAttribute(TYPE_EFFECT+TYPE_SPIRIT,ATTRIBUTE_LIGHT,RACE_PSYCHO,3,0,0)
			Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
			tc:AddMonsterAttributeComplete()
			local e1_2_1=Effect.CreateEffect(c)
			e1_2_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1_2_1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1_2_1:SetCode(EVENT_SPSUMMON_SUCCESS)
			e1_2_1:SetOperation(c1111017.op1_2_1)
			tc:RegisterEffect(e1_2_1)
			tc=tg:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end
--
function c1111017.op1_2_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1_2_1_1=Effect.CreateEffect(c)
	e1_2_1_1:SetDescription(1104)
	e1_2_1_1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1_2_1_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1_2_1_1:SetCode(EVENT_PHASE+PHASE_END)
	e1_2_1_1:SetRange(LOCATION_MZONE)
	e1_2_1_1:SetCountLimit(1)
	e1_2_1_1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e1_2_1_1:SetCondition(aux.SpiritReturnCondition)
	e1_2_1_1:SetTarget(c1111017.tg1_2_1_1)
	e1_2_1_1:SetOperation(c1111017.op1_2_1_1)
	c:RegisterEffect(e1_2_1_1)
	local e1_2_1_2=e1_2_1_1:Clone()
	e1_2_1_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	c:RegisterEffect(e1_2_1_2)
end
--
function c1111017.tg1_2_1_1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:IsHasType(EFFECT_TYPE_TRIGGER_F) then
			return true
		else
			return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end
--
function c1111017.op1_2_1_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if not c:IsFaceup() then return end
	if Duel.SendtoHand(c,nil,REASON_EFFECT)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()<1 then return end
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
end
--
function c1111017.tfilter2_1(c)
	return muxu.check_set_Soul(c) and not c:IsForbidden()
end
function c1111017.tfilter2_2(c)
	return muxu.check_set_Legend(c) and c:IsAbleToGrave()
end
function c1111017.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c1111017.tfilter2_1,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c1111017.tfilter2_2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
--
function c1111017.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1111017,1))
	local tg=Duel.SelectMatchingCard(tp,c1111017.tfilter2_1,tp,LOCATION_GRAVE,0,1,1,nil)
	if tg:GetCount()<1 then return end
	local tc=tg:GetFirst()
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,c1111017.tfilter2_2,tp,LOCATION_DECK,0,1,1,nil)
	if sg:GetCount()<1 then return end
	local sc=sg:GetFirst()
	Duel.SendtoGrave(sc,REASON_EFFECT)
end
--
