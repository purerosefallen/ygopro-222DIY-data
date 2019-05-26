--幻量子掌控者
if not pcall(function() require("expansions/script/c18007001") end) then require("script/c18007001") end
local m=18007008
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1,e2=rspq.FusionSummonFun(c,m,true,true,4)
	local e3=rspq.LeaveFieldFun(c,m)
	local e4=rsef.I(c,{m,0},1,"td,se,th","tg",LOCATION_MZONE,nil,nil,rstg.target({cm.tdfilter,"td",LOCATION_MZONE },rsop.list(cm.thfilter,"th",LOCATION_DECK)),cm.tdop)
end
cm.rssetcode="PhantomQuantum"
function cm.tdfilter(c)
	return c:IsAbleToDeck() and c:CheckSetCard("PhantomQuantum")
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:CheckSetCard("PhantomQuantum")
end
function cm.tdop(e,tp)
	local tc=rscf.GetTargetCard()
	if not tc or Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)<=0 or not tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then return end
	rsof.SelectHint(tp,"th")
	local tg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end