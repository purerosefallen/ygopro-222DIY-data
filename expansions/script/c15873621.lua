--人格面具-撒坦奈尔
if not pcall(function() require("expansions/script/c15873611") end) then require("script/c15873611") end
local m=15873621
local cm=_G["c"..m]
function cm.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	rsphh.SetCode(c,true)   
	local e1=rscf.SetSummonCondition(c,false,cm.spval,true)
	local e2=rsef.FV_IMMUNE_EFFECT(c,rsval.imoe,cm.imtg,{LOCATION_MZONE,0}) 
	local e3=rsef.QO(c,nil,{m,0},{1,m},"dis,des",nil,LOCATION_MZONE,nil,rscost.cost(cm.resfilter,"res",LOCATION_MZONE),rstg.target(rsop.list(aux.disfilter1,nil,0,LOCATION_ONFIELD)),cm.disop)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_SELF_TOGRAVE)
	e4:SetCondition(cm.rcon)
	c:RegisterEffect(e4)  
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e5:SetCondition(cm.rcon)
	e5:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e5)
end
function cm.rcon(e)
	return not Duel.IsExistingMatchingCard(rscf.FilterFaceUp(rsphh.set),e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function cm.spval(e,se)
	return se and se:IsActivated() and se:GetHandler():IsCode(15873638)
end
function cm.imtg(e,c)
	return rsphh.set(c) or rsphh.set2(c)
end
function cm.resfilter(c,e,tp)
	return rsphh.set(c) and c:IsReleasable() 
end
function cm.disfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and aux.disfilter1(c)
end
function cm.disop(e,tp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(cm.disfilter,tp,0,LOCATION_ONFIELD,nil)
	if #g1<=0 and #g2<=0 then return end
	local op=rsof.SelectOption(tp,#g1>0,{m,1},#g2>0,{m,2})
	local g=Group.CreateGroup()
	if op==1 then g:Merge(g1)
	else
		g:Merge(g2)
	end
	local fid=c:GetFieldID()
	for tc in aux.Next(g) do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1,e2=rsef.SV_LIMIT({c,tc},"dis,dise",nil,nil,rsreset.est)
		tc:RegisterFlagEffect(m,RESET_EVENT+PHASE_END,0,1,fid)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	g:KeepAlive()
	e1:SetLabelObject(g)
	e1:SetCondition(cm.descon)
	e1:SetOperation(cm.desop)
	Duel.RegisterEffect(e1,tp)
end
function cm.desfilter(c,fid)
	return c:GetFlagEffectLabel(m)==fid
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(cm.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(cm.desfilter,nil,e:GetLabel())
	Duel.Destroy(tg,REASON_EFFECT)
end