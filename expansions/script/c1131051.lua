--外环商店
local m=1131051
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
--
function c1131051.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1131051.tg1)
	e1:SetOperation(c1131051.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c1131051.cost2)
	e2:SetTarget(c1131051.tg2)
	e2:SetOperation(c1131051.op2)
	c:RegisterEffect(e2)
--
end
--
function c1131051.tfilter1(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER) and muxu.check_set_Hinbackc(c) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function c1131051.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1131051.tfilter1,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_MZONE+LOCATION_HAND)
end
--
function c1131051.ofilter1_1(c)
	return c:IsAbleToHand() and c:IsType(TYPE_EQUIP)
end
function c1131051.ofilter1_2(c,tc)
	return c:IsAbleToHand() and c:IsType(TYPE_EQUIP) and not c:IsCode(tc:GetCode())
end
function c1131051.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,c1131051.tfilter1,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
	if sg:GetCount()<1 then return end
	local sc=sg:GetFirst()
	local lv=sc:GetLevel()
	local ln=0
	if sc:IsLocation(LOCATION_HAND) then ln=1 end
	if sc:IsLocation(LOCATION_MZONE) then ln=2 end
	if Duel.Remove(sc,POS_FACEUP,REASON_COST+REASON_TEMPORARY)>0 then
		local fid=c:GetFieldID()
		local og=Duel.GetOperatedGroup()
		local oc=og:GetFirst()
		while oc do
			oc:RegisterFlagEffect(1131051,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
			oc=og:GetNext()
		end
		og:KeepAlive()
		if ln==1 then
			local e1_3=Effect.CreateEffect(c)
			e1_3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1_3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1_3:SetCode(EVENT_PHASE+PHASE_END)
			e1_3:SetCountLimit(1)
			e1_3:SetLabel(fid)
			e1_3:SetLabelObject(og)
			e1_3:SetCondition(c1131051.con1_3)
			e1_3:SetOperation(c1131051.op1_3)
			e1_3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1_3,tp)
		elseif ln==2 then
			local e1_4=Effect.CreateEffect(c)
			e1_4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1_4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1_4:SetCode(EVENT_PHASE+PHASE_END)
			e1_4:SetCountLimit(1)
			e1_4:SetLabel(fid)
			e1_4:SetLabelObject(og)
			e1_4:SetCondition(c1131051.con1_4)
			e1_4:SetOperation(c1131051.op1_4)
			e1_4:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1_4,tp)
		end
		local b1=Duel.IsExistingMatchingCard(c1131051.ofilter1_1,tp,LOCATION_DECK,0,1,nil)
		local bg=Duel.GetDecktopGroup(tp,lv*2)
		local b2=lv>0 and bg:GetCount()>0 and bg:IsExists(Card.IsAbleToHand,1,nil)
		if not (b1 or b2) then return end
		if Duel.SelectYesNo(tp,aux.Stringid(1131051,0)) then
			local off=1
			local ops={}
			local opval={}
			if b1 then
				ops[off]=aux.Stringid(1131051,1)
				opval[off-1]=1
				off=off+1
			end
			if b2 then
				ops[off]=aux.Stringid(1131051,2)
				opval[off-1]=2
				off=off+1
			end
			local op=Duel.SelectOption(tp,table.unpack(ops))
			local sel=opval[op]
			if sel==1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local tg=Duel.SelectMatchingCard(tp,c1131051.ofilter1_1,tp,LOCATION_DECK,0,1,1,nil)
				if tg:GetCount()<1 then return end
				local tc=tg:GetFirst()
				if Duel.IsExistingMatchingCard(c1131051.ofilter1_2,tp,LOCATION_DECK,0,1,nil,tc) and Duel.SelectYesNo(tp,aux.Stringid(1131051,3)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
					local tg2=Duel.SelectMatchingCard(tp,c1131051.ofilter1_2,tp,LOCATION_DECK,0,1,1,nil,tc)
					if tg2:GetCount()>0 then tg:Merge(tg2) end
				end
				Duel.SendtoHand(tg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tg)
			else
				Duel.ConfirmDecktop(tp,lv*2)
				local lg=bg:Filter(Card.IsAbleToHand,nil)
				if lg:GetCount()<1 then return end
				local ng=lg:Select(tp,1,1,nil)
				if ng:GetCount()<1 then return end
				Duel.SendtoHand(ng,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,ng)
			end
		end
	end
end
--
function c1131051.cfilter1_3(c,fid)
	return c:GetFlagEffectLabel(1131051)==fid
end
function c1131051.con1_3(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c1131051.cfilter1_3,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c1131051.op1_3(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c1131051.cfilter1_3,nil,e:GetLabel())
	g:DeleteGroup()
	local tc=sg:GetFirst()
	while tc do
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		tc=sg:GetNext()
	end
end
--
function c1131051.cfilter1_4(c,fid)
	return c:GetFlagEffectLabel(1131051)==fid
end
function c1131051.con1_4(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c1131051.cfilter1_4,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c1131051.op1_4(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c1131051.cfilter1_4,nil,e:GetLabel())
	g:DeleteGroup()
	local tc=sg:GetFirst()
	while tc do
		Duel.ReturnToField(tc)
		tc=sg:GetNext()
	end
end
--
function c1131051.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local sg=Group.CreateGroup()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	sg:AddCard(c)
	Duel.HintSelection(sg)
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
--
function c1131051.tfilter2_1(c)
	return c:IsFaceup() and muxu.check_set_Hinbackc(c) and c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c1131051.tfilter2_2,tp,LOCATION_GRAVE,0,1,nil,c)
end
function c1131051.tfilter2_2(c,ec)
	return c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec) and not c:IsForbidden()
end
function c1131051.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c1131051.tfilter2_1(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c1131051.tfilter2_1,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local sg=Duel.SelectTarget(tp,c1131051.tfilter2_1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
end
--
function c1131051.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() then return end
	if not tc:IsRelateToEffect(e) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<1 then return end
	local eq=Duel.GetMatchingGroup(c1131051.tfilter2_2,tp,LOCATION_GRAVE,0,nil,c)
	if eq:GetCount()<1 then return end
	if ft>=eq:GetCount() then 
		local ec=eq:GetFirst()
		while ec do
			if Duel.Equip(tp,ec,tc,true,true) then
				local e2_1=Effect.CreateEffect(c)
				e2_1:SetDescription(aux.Stringid(1131051,4))
				e2_1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e2_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2_1:SetCode(EVENT_PHASE+PHASE_END)
				e2_1:SetRange(LOCATION_SZONE)
				e2_1:SetCountLimit(1)
				e2_1:SetCondition(c1131051.con2_1)
				e2_1:SetOperation(c1131051.op2_1)
				e2_1:SetReset(RESET_EVENT+0x1fe0000)
				ec:RegisterEffect(e2_1)
			end
			ec=eq:GetNext()
		end
		Duel.EquipComplete()
	else
		for i=1,ft do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local ec=eq:Select(tp,1,1,nil):GetFirst()
			eq:RemoveCard(ec)
			if Duel.Equip(tp,ec,tc,true,true) then
				local e2_1=Effect.CreateEffect(c)
				e2_1:SetDescription(aux.Stringid(1131051,4))
				e2_1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e2_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2_1:SetCode(EVENT_PHASE+PHASE_END)
				e2_1:SetRange(LOCATION_SZONE)
				e2_1:SetCountLimit(1)
				e2_1:SetCondition(c1131051.con2_1)
				e2_1:SetOperation(c1131051.op2_1)
				e2_1:SetReset(RESET_EVENT+0x1fe0000)
				ec:RegisterEffect(e2_1)
			end
		end
		Duel.EquipComplete()
	end
end
--
function c1131051.con2_1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c1131051.op2_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
end
--
