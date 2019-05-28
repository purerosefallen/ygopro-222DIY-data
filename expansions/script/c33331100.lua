--小狐
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=33331100
local cm=_G["c"..m]
if not rsv.LF then
	rsv.LF={}
	rslf=rsv.LF
function rslf.filter0(c)
	return c:IsSetCard(0x2553) and c:IsType(TYPE_PENDULUM)
end
function rslf.filter1(c,tp)
	return rslf.filter0(c) and Duel.GetMZoneCount(tp,c,tp)>0
end
function rslf.filter2(c)
	return c:IsRace(RACE_BEAST) and c:IsType(TYPE_NORMAL)
end
function rslf.SpecialSummonFunction(c,code,con,op,buff)
	aux.EnablePendulumAttribute(c)
	if not c:IsStatus(STATUS_COPYING_EFFECT) then
		local mt=getmetatable(c)
		if not mt.lflist then
			mt.lflist=buff
		end
	end
	local e1=rscf.SetSpecialSummonProduce(c,LOCATION_PZONE,rslf.sscon(con),rslf.ssop(op,buff))
	if code then
		e1:SetCountLimit(1,code)
	end
	return e1
end
function rslf.sscon(con)
	return function(e,c)
		if c==nil then return true end
		local tp=c:GetControler()
		return con(e,tp,c)
	end
end
function rslf.ssop(op,buff)
	return function(e,tp,eg,ep,ev,re,r,rp,c)
		op(e,tp,c)
		rslf.buffop(c,c,buff)
	end
end
function rslf.buffop(c1,c2,buff,bool)
	--just optimize,no problem there. if crash, must have other problems
	if buff and type(buff)=="function" then
		local reset=not bool and RESET_EVENT+RESETS_STANDARD-RESET_LEAVE-RESET_TOFIELD+RESET_OVERLAY or RESET_EVENT+RESETS_STANDARD 
		local list={buff(c2)}
		if #list==0 then return end
		for k,buffeffect in pairs(list) do
			buffeffect:SetRange(LOCATION_MZONE)
			buffeffect:SetReset(reset)
		end 
		c2:RegisterFlagEffect(m,reset,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(c1:GetOriginalCode(),2))  
		if not c2:IsType(TYPE_EFFECT) then
			local e2=Effect.CreateEffect(c1)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_ADD_TYPE)
			e2:SetValue(TYPE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			c2:RegisterEffect(e2,true)
		end
	end
end
--------------
end
-------------
if cm then
function cm.initial_effect(c)
	local e1=rslf.SpecialSummonFunction(c,m,cm.con,cm.op) 
	e1:SetValue(1)
	local e2=rsef.SC(c,EVENT_SPSUMMON_SUCCESS,nil,nil,"cd,uc",cm.spcon,cm.spop)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function cm.spop(e,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	if sumtype&SUMMON_TYPE_LINK ==0 then return false end
	return not c:IsSetCard(0x2553)
end
function cm.cfilter(c,tp)
	return rslf.filter1(c,tp) and not c:IsForbidden()
end
function cm.con(e,tp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_DECK,0,1,nil,tp)
end
function cm.op(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local tc=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	local b2=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local op=rsof.SelectOption(tp,true,{m,0},b2,{m,1})
	if op==1 then
		Duel.SendtoExtraP(tc,nil,REASON_COST)
	else
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
-------------
end
