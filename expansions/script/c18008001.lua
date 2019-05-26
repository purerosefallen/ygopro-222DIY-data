--新干线700铁路之星
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=18008001
local cm=_G["c"..m]
if not rsv.Shinkansen then
	rsv.Shinkansen={}
	rssk=rsv.Shinkansen
function rssk.set(c)
	return c:CheckSetCard("Shinkansen")
end
function rssk.lset(c)
	return c:CheckLinkSetCard("Shinkansen")
end
function rssk.nmcon(e,tp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function rssk.SpecialSummonFun(c)
	local e1=rsef.I(c,{m,0},nil,"sp",nil,LOCATION_HAND,rssk.nmcon,nil,rssk.sptg,rssk.spop)
	return e1
end
function rssk.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function rssk.limit(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(rssk.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function rssk.spop(e,tp)
	local c=e:GetHandler()
	rssk.limit(c)
	if c:IsRelateToEffect(e) then rssf.SpecialSummon(c) end
end
function rssk.splimit(e,c)
	return not rssk.set(c)
end
function rssk.LinkFun(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_MACHINE),2)
	local e1=rssk.LimitSpFun(c)
	return e1
end
function rssk.LimitSpFun(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MUST_USE_MZONE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(0xff)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(function(e,rc) return rc.rssetcode=="Shinkansen" and rc:IsType(TYPE_LINK) end)
	e1:SetValue(rssk.frcval)
	--c:RegisterEffect(e1)
	return e1
end
function rssk.lkfilter(c)
	return c:IsType(TYPE_LINK) and c:IsFaceup() and rssk.set(c)
end
function rssk.frcval(e,c,fp,rp,r)
	local zone=0
	local g=Duel.GetMatchingGroup(rssk.lkfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		zone=zone|tc:GetLinkedZone()
	end 
	if r==0x1 then 
		return 0x7f 
	else
		return zone
	end
end
function rssk.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
		local fid=c:GetFieldID()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,1))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()<=PHASE_STANDBY then
			e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
			e1:SetValue(Duel.GetTurnCount())
			c:RegisterFlagEffect(m,RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,2,fid)
		else
			e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
			e1:SetValue(0)
			c:RegisterFlagEffect(m,RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1,fid)
		end
		e1:SetLabel(fid)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetCondition(rssk.retcon)
		e1:SetOperation(rssk.retop)
		Duel.RegisterEffect(e1,tp)
	end 
end
function rssk.retcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp or Duel.GetTurnCount()==e:GetValue() then return false end
	return e:GetLabelObject():GetFlagEffectLabel(m)==e:GetLabel()
end
function rssk.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function rssk.cfilter(c,tp,zone)
	local seq=c:GetPreviousSequence()
	if c:GetPreviousControler()~=tp then seq=seq+16 end
	return c:IsFaceup()
		and c:IsPreviousLocation(LOCATION_MZONE) and bit.extract(zone,seq)~=0
end
function rssk.lfcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(rssk.cfilter,1,nil,tp,e:GetHandler():GetLinkedZone())
end
function rssk.link()
	local tg=function(e,c)
		return c:IsLinkState() and rssk.set(c)
	end
	local tgrange={LOCATION_MZONE,0}
	local con=function(e,tp)
		return e:GetHandler():IsLinkState()
	end
	return {tg,tgrange,con}
end
---------
end
---------
if cm then
function cm.initial_effect(c)
	local e1=rsef.QO(c,nil,{m,0},nil,"sp",nil,LOCATION_HAND,rssk.nmcon,rscost.regflag(m),rssk.sptg,cm.spop)   
	local e2=rsef.SV_IMMUNE_EFFECT(c,rsval.imoe,cm.con)
end
cm.rssetcode="Shinkansen"
function cm.con(e,tp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
end
function cm.spop(e,tp)
	local c=e:GetHandler()
	rssk.limit(c)
	if c:IsRelateToEffect(e) and rssf.SpecialSummon(c)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_ONLY_ATTACK_MONSTER)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetValue(cm.atklimit)
		e1:SetLabel(c:GetRealFieldID())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.atklimit(e,c)
	return c:GetRealFieldID()==e:GetLabel()
end
---------
end
