--灵都·粉梦初心
local m=1110001
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Urban=true
--
function c1110001.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,1110001)
	e1:SetCost(c1110001.cost1)
	e1:SetTarget(c1110001.tg1)
	e1:SetOperation(c1110001.op1)
	c:RegisterEffect(e1)
--
end
--
function c1110001.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if not Duel.CheckLPCost(tp,600) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(1110001,0)) then return end
	Duel.PayLPCost(tp,600)
	e:SetLabel(1)
end
--
function c1110001.tfilter1(c)
	return c:IsCode(1110002) and c:IsFaceup()
end
function c1110001.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c1110001.tfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1110001.tfilter1,tp,LOCATION_MZONE,0,1,nil) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g=Duel.SelectTarget(tp,c1110001.tfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,LOCATION_HAND)
	if not e:GetLabel() then return end
	if e:GetLabel()~=1 then return end
	Duel.SetChainLimit(aux.FALSE)
end
--
function c1110001.ofilter1_1(c)
	return c:IsCode(1111001) and c:IsSSetable()
end
function c1110001.ofilter1_2(c,e,tp)
	return c:IsCode(1110198) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1110001.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local b1=tc:IsRelateToEffect(e) and tc:IsAbleToHand() and Duel.IsExistingMatchingCard(c1110001.ofilter1_1,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		local b2=Duel.IsExistingMatchingCard(c1110001.ofilter1_2,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		if not (b1 or b2) then return end
		if Duel.SelectYesNo(tp,aux.Stringid(1110001,1)) then
			local off=1
			local ops={}
			local opval={}
			if b1 then
				ops[off]=aux.Stringid(1110001,2)
				opval[off-1]=1
				off=off+1
			end
			if b2 then
				ops[off]=aux.Stringid(1110001,3)
				opval[off-1]=2
				off=off+1
			end
			local op=Duel.SelectOption(tp,table.unpack(ops))
			local sel=opval[op]
			e:SetLabel(sel)
			if sel==1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
				local g=Duel.SelectMatchingCard(tp,c1110001.ofilter1_1,tp,LOCATION_DECK,0,1,1,nil)
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.SSet(tp,g)
				Duel.ConfirmCards(1-tp,g)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,c1110001.ofilter1_2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
				local tc=g:GetFirst()
				Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
				local e1_1=Effect.CreateEffect(c)
				e1_1:SetType(EFFECT_TYPE_SINGLE)
				e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1_1:SetCode(EFFECT_ADD_TYPE)
				e1_1:SetValue(TYPE_SPIRIT)
				e1_1:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1_1,true)
				tc:RegisterFlagEffect(1110001,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(1110001,8))
				Duel.SpecialSummonComplete()
			end
		end
	end
end