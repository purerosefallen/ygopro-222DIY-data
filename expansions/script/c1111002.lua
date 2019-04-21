--蝶舞·莲梦
local m=1111002
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Butterfly=true
--
function c1111002.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1111002+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c1111002.tg1)
	e1:SetOperation(c1111002.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c1111002.tg2)
	e2:SetOperation(c1111002.op2)
	c:RegisterEffect(e2)
--
end
--
function c1111002.tfilter1_1(c,tp)
	return muxu.check_set_Urban(c)
		and c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
		and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c1111002.tfilter1_2(c,e,tp)
	return muxu.check_set_Urban(c) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1111002.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then
		return chkc:IsControler(tp) and c1111002.tfilter1_1(chkc,tp)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c1111002.tfilter1_1,tp,LOCATION_MZONE,0,1,nil,tp)
			and Duel.IsExistingTarget(c1111002.tfilter1_2,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local rg=Duel.SelectTarget(tp,c1111002.tfilter1_1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,rg,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
--
function c1111002.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)<1 then return end
	if Duel.GetLocationCountFromEx(tp)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c1111002.tfilter1_2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1_2=Effect.CreateEffect(c)
	e1_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1_2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1_2:SetCountLimit(1)
	e1_2:SetOperation(c1111002.op1_2)
	e1_2:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1_2,tp)
end
--
function c1111002.op1_2(e,tp,eg,ep,ev,re,r,rp)
	local lg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,63,nil)
	if lg:GetCount()<1 then return end
	if Duel.SendtoDeck(lg,nil,2,REASON_EFFECT)<1 then return end
	local num1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local num2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if num1>=num2 then return end
	Duel.Draw(tp,num2-num1,REASON_EFFECT)
end
--
function c1111002.tfilter2(c,tp,rp)
	return rp~=tp
		and c:GetPreviousControler()==tp
		and c:IsPreviousPosition(POS_FACEUP)
		and not c:IsReason(REASON_BATTLE)
-- or (c:IsReason(REASON_EFFECT) and re and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)))
		and muxu.check_set_Urban(c) and c:IsType(TYPE_MONSTER)
		and c:IsAbleToHand()
end
function c1111002.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand()
		and eg:IsExists(c1111002.tfilter2,1,nil,tp,rp) end
	local sg=eg:Filter(c1111002.tfilter2,nil,tp,rp)
	sg:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
--
function c1111002.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rg=eg:Filter(c1111002.tfilter2,nil,tp,rp)
	if c:IsRelateToEffect(e) then rg:AddCard(c) end
	if rg:GetCount()<1 then return end
	Duel.SendtoHand(rg,nil,REASON_EFFECT)
end
--
