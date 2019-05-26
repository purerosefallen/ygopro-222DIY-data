--新干线先锋 E7光辉
if not pcall(function() require("expansions/script/c18008001") end) then require("script/c18008001") end
local m=18008008
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rssk.LinkFun(c)   
	local e2=rsef.QO(c,nil,{m,0},{1,m},"th",nil,LOCATION_MZONE,nil,rssk.rmcost,rstg.target(rsop.list(cm.thfilter,"th",LOCATION_GRAVE)),cm.thop)
	local e3=rsef.FTO(c,EVENT_LEAVE_FIELD,{m,1},{1,m+100},"dis","de,tg,dsp",LOCATION_MZONE,rssk.lfcon,nil,rstg.target(aux.disfilter1,"dis",0,LOCATION_ONFIELD),cm.disop)
	local e4=rsef.FV_IMMUNE_EFFECT(c,cm.val,table.unpack(rssk.link()))
end
cm.rssetcode="Shinkansen"
function cm.val(e,re)
	return re:IsActivated() and re:IsActiveType(TYPE_MONSTER) and re:GetHandlerPlayer()~=e:GetHandlerPlayer()
end
function cm.disop(e,tp)
	local c=e:GetHandler()
	local tc=rscf.GetTargetCard()
	if not tc then return end
	Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	local e1,e2=rsef.SV_LIMIT({c,tc},"dis,dise",nil,nil,rsreset.est_pend)
end
function cm.thfilter(c,e,tp)
	return rssk.set(c) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	rsof.SelectHint(tp,"th")
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if #tg>0 then
		Duel.HintSelection(tg)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end