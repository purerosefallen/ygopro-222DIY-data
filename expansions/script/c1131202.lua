--盛竹桥-门
local m=1131202
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
--
function c1131202.initial_effect(c)
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_TO_DECK)
	e1:SetRange(LOCATION_ONFIELD)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1163)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC_G)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,10000000)
	e2:SetCondition(c1131202.PendCondition())
	e2:SetOperation(c1131202.PendOperation())
	e2:SetValue(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c1131202.con3)
	e3:SetOperation(c1131202.op3)
	c:RegisterEffect(e3)
--
end
--
function c1131202.PConditionFilter(c,e,tp)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	local bool=aux.PendulumSummonableBool(c)
	return  (c:IsLocation(LOCATION_HAND) 
		or c:IsLocation(LOCATION_REMOVED)
		or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
		and muxu.check_set_Hinbackc(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,bool,bool)
		and not c:IsForbidden()
end
--
function c1131202.PendCondition()
	return
	function(e,c,og)
		if c==nil then return true end
		local tp=c:GetControler()
		local seq=c:GetSequence()
		local loc=0
		local LE=Duel.GetLocationCountFromEx(tp)
		local LM=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if LE>0 then loc=loc+LOCATION_EXTRA end
		if LM>0 then loc=loc+LOCATION_HAND+LOCATION_REMOVED end
		if loc==0 then return false end
		local g=nil
		if og then
			g=og:Filter(Card.IsLocation,nil,loc)
		else
			g=Duel.GetFieldGroup(tp,loc,0)
		end
		return g:IsExists(c1131202.PConditionFilter,1,nil,e,tp)
			and (seq==0 or seq==4)
	end
end
--
function c1131202.PendOperation()
	return  
	function(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
		local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local ft2=Duel.GetLocationCountFromEx(tp)
		local ft=Duel.GetUsableMZoneCount(tp)
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then
			if ft1>0 then ft1=1 end
			if ft2>0 then ft2=1 end
			ft=1
		end
		local loc=0
		if ft1>0 then loc=loc+LOCATION_HAND+LOCATION_REMOVED end
		if ft2>0 then loc=loc+LOCATION_EXTRA end
		local tg=nil
		if og then
			tg=og:Filter(Card.IsLocation,nil,loc):Filter(c1131202.PConditionFilter,nil,e,tp)
		else
			tg=Duel.GetMatchingGroup(c1131202.PConditionFilter,tp,loc,0,nil,e,tp)
		end
		ft1=math.min(ft1,tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_REMOVED))
		ft2=math.min(ft2,tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA))
		local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
		if ect and ect<ft2 then ft2=ect end
		while true do
			local ct1=tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_REMOVED)
			local ct2=tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
			local ct=ft
			if ct1>ft1 then ct=math.min(ct,ft1) end
			if ct2>ft2 then ct=math.min(ct,ft2) end
			if ct<=0 then break end
			if sg:GetCount()>0 and not Duel.SelectYesNo(tp,210) then ft=0 break end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=tg:Select(tp,1,ct,nil)
			tg:Sub(g)
			sg:Merge(g)
			if g:GetCount()<ct then ft=0 break end
			ft=ft-g:GetCount()
			ft1=ft1-g:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_REMOVED)
			ft2=ft2-g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
		end
		if ft>0 then
			local tg1=tg:Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_REMOVED)
			local tg2=tg:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
			if ft1>0 and ft2==0 and tg1:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,210)) then
				local ct=math.min(ft1,ft)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=tg1:Select(tp,1,ct,nil)
				sg:Merge(g)
			end
			if ft1==0 and ft2>0 and tg2:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,210)) then
				local ct=math.min(ft2,ft)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=tg2:Select(tp,1,ct,nil)
				sg:Merge(g)
			end
		end
		Duel.HintSelection(Group.FromCards(c))
	end
end
--
function c1131202.cfilter3(c,seq2)
	local seq1=aux.MZoneSequence(c:GetSequence())
	return c:IsFaceup() and muxu.check_set_Hinbackc(c) and seq1==4-seq2
end
function c1131202.con3(e,tp,eg,ep,ev,re,r,rp)
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	local checknum=2
	if loc==LOCATION_SZONE then checknum=1
	elseif loc==LOCATION_MZONE then seq=aux.MZoneSequence(seq)
	else checknum=0 end
	return checknum==2 or (checknum==1 and seq<5)
		and rp==1-tp 
		and Duel.IsExistingMatchingCard(c1131202.cfilter3,tp,LOCATION_MZONE,0,1,nil,seq)
end
function c1131202.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
	local e3_1=Effect.CreateEffect(c)
	e3_1:SetType(EFFECT_TYPE_FIELD)
	e3_1:SetCode(EFFECT_IMMUNE_EFFECT)
	e3_1:SetRange(LOCATION_SZONE)
	e3_1:SetTargetRange(LOCATION_MZONE,0)
	e3_1:SetTarget(c1131202.tg3_1)
	e3_1:SetValue(c1131202.val3_1)
	e3_1:SetLabelObject(te)
	e3_1:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
	c:RegisterEffect(e3_1)
end
--
function c1131202.tg3_1(e,c)
	return c:IsFaceup() and muxu.check_set_Hinbackc(c)
end
function c1131202.val3_1(e,te)
	local re=e:GetLabelObject()
	return te==re
end
--
