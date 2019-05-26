--新干线先锋 E6小町
if not pcall(function() require("expansions/script/c18008001") end) then require("script/c18008001") end
local m=18008007
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rssk.LinkFun(c)   
	local e2=rsef.QO(c,nil,{m,0},{1,m},"se,th",nil,LOCATION_MZONE,nil,rssk.rmcost,rstg.target(rsop.list(cm.thfilter,"th",LOCATION_DECK)),cm.thop)
	local e3=rsef.FTO(c,EVENT_LEAVE_FIELD,{m,1},{1,m+100},"des","de,tg,dsp",LOCATION_MZONE,rssk.lfcon,nil,rstg.target(aux.TRUE,"rm",0,LOCATION_MZONE),cm.desop)
	local e4=rsef.FV_UPDATE(c,"atk",500,table.unpack(rssk.link()))
end
cm.rssetcode="Shinkansen"
function cm.desop(e,tp)
	local tc=rscf.GetTargetCard()
	if tc then Duel.Destroy(tc,REASON_EFFECT) end
end
function cm.thfilter(c,e,tp)
	return rssk.set(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	rsof.SelectHint(tp,"th")
	local tg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end