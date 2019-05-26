--新干线先锋 E3翼
if not pcall(function() require("expansions/script/c18008001") end) then require("script/c18008001") end
local m=18008005
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rssk.LinkFun(c)   
	local e2=rsef.QO(c,nil,{m,0},{1,m},nil,nil,LOCATION_MZONE,nil,rssk.rmcost,rstg.target(rsop.list(cm.setfilter,nil,LOCATION_DECK)),cm.setop)
	local e3=rsef.FTO(c,EVENT_LEAVE_FIELD,{m,1},{1,m+100},"rm","de,tg,dsp",LOCATION_MZONE,rssk.lfcon,nil,rstg.target(cm.rmfilter,"rm",0,LOCATION_ONFIELD),cm.rmop)
	local e4=rsef.FV_INDESTRUCTABLE(c,"effect",aux.indoval,table.unpack(rssk.link()))
end
cm.rssetcode="Shinkansen"
function cm.rmfilter(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_TRAP+TYPE_SPELL)
end
function cm.rmop(e,tp)
	local tc=rscf.GetTargetCard()
	if tc then Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) end
end
function cm.setfilter(c,e,tp)
	return rssk.set(c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function cm.setop(e,tp)
	rsof.SelectHint(tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end