--命运之书
local m=1110114
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Urban=true
--
function c1110114.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,c1110114.FusFilter1,c1110114.FusFilter2)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c1110114.con1)
	e1:SetOperation(c1110114.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c1110114.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c1110114.op3)
	c:RegisterEffect(e3)
--
end
--
function c1110114.FusFilter1(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_MONSTER)
end
--
function c1110114.FusFilter2(c)
	return muxu.check_fusion_set_Urban(c)
end
--
function c1110114.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(1110114)<1
end
--
function c1110114.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(1110114,RESET_EVENT+0x1fe0000,0,1)
	local fg=c:GetMaterial()
	if fg:GetCount()<1 then return end
	local fc=fg:GetFirst()
	while fc do
		if bit.band(fc:GetOriginalType(),TYPE_MONSTER)~=0 and fc:IsType(TYPE_EFFECT) then
			local code=fc:GetOriginalCode()
			c:CopyEffect(code,RESET_EVENT+0x1fe0000,0,1)
		end
		fc=fg:GetNext()
	end
end
--
function c1110114.op2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not rc:IsControler(tp) then return end
	if not rc:IsRelateToEffect(re) then return end
	if not muxu.check_set_Legend(rc) then return end
	rc:RegisterFlagEffect(1110114,RESET_EVENT+0x1fe0000,0,0)
end
--
function c1110114.ofilter3_1(c,tp)
	return c:GetFlagEffect(1110114)>0
		and c:IsStatus(STATUS_LEAVE_CONFIRMED)
end
function c1110114.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetMZoneCount(tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local sg=Duel.GetMatchingGroup(c1110114.ofilter3_1,tp,LOCATION_SZONE,0,nil,tp)
	if sg:GetCount()<1 then return end
	local ng=Group.CreateGroup()
	local lc=sg:GetFirst()
	while lc do
		Duel.ResetFlagEffect(lc,1110114)
		if Duel.IsPlayerCanSpecialSummonMonster(tp,lc:GetCode(),nil,0x221,0,0,3,RACE_PSYCHO,ATTRIBUTE_LIGHT,POS_FACEUP) then 
			ng:AddCard(lc) 
		end
		lc=sg:GetNext()
	end
	local num=ng:GetCount()
	if num<1 then return end
	if ft<num then num=ft end
	if Duel.SelectYesNo(tp,aux.Stringid(1110114,0)) then
		if num>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=ng:Select(tp,1,num,nil)
			local tc=tg:GetFirst()
			while tc do
				tc:AddMonsterAttribute(TYPE_EFFECT+TYPE_SPIRIT,ATTRIBUTE_LIGHT,RACE_PSYCHO,3,0,0)
				Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
				tc:AddMonsterAttributeComplete()
				local e3_2=Effect.CreateEffect(c)
				e3_2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
				e3_2:SetCode(EVENT_SPSUMMON_SUCCESS)
				e3_2:SetOperation(c1110114.op3_2)
				tc:RegisterEffect(e3_2,true)
				tc=tg:GetNext()
			end
			Duel.SpecialSummonComplete()
		else
			local nc=ng:GetFirst()
			nc:AddMonsterAttribute(TYPE_EFFECT+TYPE_SPIRIT,ATTRIBUTE_LIGHT,RACE_PSYCHO,3,0,0)
			Duel.SpecialSummonStep(nc,0,tp,tp,true,false,POS_FACEUP)
			nc:AddMonsterAttributeComplete()
			local e3_2=Effect.CreateEffect(c)
			e3_2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e3_2:SetCode(EVENT_SPSUMMON_SUCCESS)
			e3_2:SetOperation(c1110114.op3_2)
			nc:RegisterEffect(e3_2,true)
			Duel.SpecialSummonComplete()
		end
	end
end
--
function c1110114.op3_2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e3_3=Effect.CreateEffect(c)
	e3_3:SetDescription(1104)
	e3_3:SetCategory(CATEGORY_TOHAND)
	e3_3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3_3:SetCode(EVENT_PHASE+PHASE_END)
	e3_3:SetRange(LOCATION_MZONE)
	e3_3:SetCountLimit(1)
	e3_3:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e3_3:SetCondition(aux.SpiritReturnCondition)
	e3_3:SetTarget(c1110114.tg3_3)
	e3_3:SetOperation(c1110114.op3_3)
	c:RegisterEffect(e3_3)
	local e3_4=e3_3:Clone()
	e3_4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	c:RegisterEffect(e3_4)
end
--
function c1110114.tg3_3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:IsHasType(EFFECT_TYPE_TRIGGER_F) then return true
		else return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end
--
function c1110114.op3_3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() then return end
	if not c:IsRelateToEffect(e) then return end
	Duel.SendtoHand(c,nil,REASON_EFFECT)
end
--
