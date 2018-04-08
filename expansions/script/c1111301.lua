--蝶舞·邂逅终路的迷榖
local m=1111301
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Butterfly=true
--
function c1111301.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1111301.tg1)
	e1:SetOperation(c1111301.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c1111301.cost2)
	e2:SetTarget(c1111301.tg2)
	e2:SetOperation(c1111301.op2)
	c:RegisterEffect(e2)	
--
end
--
function c1111301.filter(c,e,tp,m)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	if c.mat_filter then
		m=m:Filter(c.mat_filter,nil)
	end
	return m:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
end
function c1111301.matfilter(c)
	return c:IsAbleToRemove() and c:GetLevel()>0 and c:GetLevel()<10 
end
function c1111301.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local mg=Duel.GetMatchingGroup(c1111301.matfilter,tp,LOCATION_GRAVE,0,nil)
		return Duel.IsExistingMatchingCard(c1111301.filter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_REMOVED)
end
--
function c1111301.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local mg=Duel.GetMatchingGroup(c1111301.matfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c1111301.filter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,1,nil,e,tp,mg)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,nil)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
		tc:SetMaterial(mat)
		Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
		Duel.BreakEffect()
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetRange(LOCATION_MZONE)
		e1_1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1_1:SetValue(c1111301.efilter1_1)
		e1_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1_1)
	end
end
--
function c1111301.efilter1_1(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
--
function c1111301.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(1111301,0))
end
--
function c1111301.tfilter2(c)
	return muxu.check_set_Legend(c) and c:IsSSetable()
end
function c1111301.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c1111301.tfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1111301.tfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=Duel.SelectTarget(tp,c1111301.tfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,sg,1,0,0)
end
--
function c1111301.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end
--
