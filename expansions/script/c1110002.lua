--灵都·稠蜜幻景
local m=1110002
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Urban=true
--
function c1110002.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,1110002)
	e1:SetCost(c1110002.cost1)
	e1:SetTarget(c1110002.tg1)
	e1:SetOperation(c1110002.op1)
	c:RegisterEffect(e1)
--
end
--
function c1110002.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if not Duel.CheckLPCost(tp,600) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(1110002,0)) then return end
	Duel.PayLPCost(tp,600)
	e:SetLabel(1)
end
--
function c1110002.tfilter1(c)
	return c:IsCode(1110001) and c:IsFaceup()
end
function c1110002.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c1110002.tfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1110002.tfilter1,tp,LOCATION_MZONE,0,1,nil) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g=Duel.SelectTarget(tp,c1110002.tfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,LOCATION_HAND)
	if not e:GetLabel() then return end
	if e:GetLabel()~=1 then return end
	Duel.SetChainLimit(aux.FALSE)
end
--
function c1110002.ofilter1(c)
	return muxu.check_set_Urban(c) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_FIELD) and c:IsSSetable()
end
function c1110002.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local b1=Duel.IsExistingMatchingCard(c1110002.ofilter1,tp,LOCATION_DECK,0,1,nil)
		local b2=tc:IsRelateToEffect(e)
		if not (b1 or b2) then return end
		if Duel.SelectYesNo(tp,aux.Stringid(1110002,1)) then
			local off=1
			local ops={}
			local opval={}
			if b1 then
				ops[off]=aux.Stringid(1110002,2)
				opval[off-1]=1
				off=off+1
			end
			if b2 then
				ops[off]=aux.Stringid(1110002,3)
				opval[off-1]=2
				off=off+1
			end
			local op=Duel.SelectOption(tp,table.unpack(ops))
			local sel=opval[op]
			e:SetLabel(sel)
			if sel==1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
				local g=Duel.SelectMatchingCard(tp,c1110002.ofilter1,tp,LOCATION_DECK,0,1,1,nil)
				Duel.SSet(tp,g)
				Duel.ConfirmCards(1-tp,g)
			else
				local e1_1=Effect.CreateEffect(c)
				e1_1:SetType(EFFECT_TYPE_SINGLE)
				e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1_1:SetCode(EFFECT_ADD_TYPE)
				e1_1:SetValue(TYPE_SPIRIT)
				e1_1:SetReset(RESET_EVENT+0x1fe0000)
				c:RegisterEffect(e1_1)
				local e1_2=Effect.CreateEffect(c)
				e1_2:SetType(EFFECT_TYPE_SINGLE)
				e1_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1_2:SetCode(EFFECT_ADD_TYPE)
				e1_2:SetValue(TYPE_SPIRIT)
				e1_2:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1_2)
				c:RegisterFlagEffect(1110002,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(1110002,8))
				tc:RegisterFlagEffect(1110002,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(1110002,8))
				local e1_3=Effect.CreateEffect(c)
				e1_3:SetType(EFFECT_TYPE_FIELD)
				e1_3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1_3:SetCode(EFFECT_CANNOT_ACTIVATE)
				e1_3:SetTargetRange(0,1)
				e1_3:SetValue(c1110002.val1_3)
				e1_3:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1_3,tp)
			end
		end
	end
end
--
function c1110002.val1_3(e,re,tp)
	return not re:GetHandler():IsLocation(LOCATION_ONFIELD)
end
--

