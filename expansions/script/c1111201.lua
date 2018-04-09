--灵都·流莹水榭
local m=1111201
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Urban=true
--
function c1111201.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c1111201.con2)
	e2:SetTarget(c1111201.tg2)
	e2:SetOperation(c1111201.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1111201,3))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c1111201.con3)
	e3:SetOperation(c1111201.op3)
	c:RegisterEffect(e3)
--
end
--
function c1111201.cfilter2(c,tp)
	return c:IsControler(1-tp) and c:IsPreviousLocation(LOCATION_DECK) and not c:IsReason(REASON_DRAW)
end
function c1111201.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1111201.cfilter2,1,nil,tp)
end
--
function c1111201.tfilter2_2(c)
	return c:IsAbleToHand() and muxu.check_set_Legend(c) 
end
function c1111201.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetFlagEffect(tp,1111218)<1
	local b2=Duel.IsExistingMatchingCard(c1111201.tfilter2_2,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,1111219)<1
	local b3=Duel.GetFlagEffect(tp,1111220)<1
	if chk==0 then return b1 or b2 or b3 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(1111201,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(1111201,1)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(1111201,2)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.SetTargetCard(eg)
		Duel.RegisterFlagEffect(tp,1111218,RESET_PHASE+PHASE_END,0,1)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,eg,eg:GetCount(),0,0)
	elseif sel==2 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		Duel.RegisterFlagEffect(tp,1111219,RESET_PHASE+PHASE_END,0,1)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
	else
		Duel.RegisterFlagEffect(tp,1111220,RESET_PHASE+PHASE_END,0,1)
	end
end
--
function c1111201.ofilter2_1(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsControler(1-tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c1111201.op2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		local sg=eg:Filter(c1111201.ofilter2_1,nil,e,tp)
		if sg:GetCount()<1 then return end
		Duel.SendtoGrave(sg,REASON_EFFECT)
	elseif sel==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c1111201.tfilter2_2,tp,LOCATION_DECK,0,1,1,nil)
		if sg:GetCount()<1 then return end
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	else
		local e2_3=Effect.CreateEffect(c)
		e2_3:SetType(EFFECT_TYPE_FIELD)
		e2_3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2_3:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2_3:SetTargetRange(1,1)
		e2_3:SetValue(c1111201.val2_3)
		if Duel.GetTurnPlayer()~=tp then
			e2_3:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
		else
			e2_3:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		end
		Duel.RegisterEffect(e2_3,tp)
	end
end
--
function c1111201.val2_3(e,re,tp)
	return re:IsHasProperty(EFFECT_FLAG_CANNOT_DISABLE)
end
--
function c1111201.con3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if bc:IsControler(1-tp) then bc=tc end
	e:SetLabelObject(bc)
	return bc:IsFaceup() and muxu.check_set_Urban(bc)
end
--
function c1111201.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc:IsRelateToBattle() and tc:IsFaceup() and tc:IsControler(tp) then
		local e3_1=Effect.CreateEffect(c)
		e3_1:SetType(EFFECT_TYPE_SINGLE)
		e3_1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3_1:SetValue(tc:GetAttack()*2)
		e3_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
		tc:RegisterEffect(e3_1)
	end
end
--

