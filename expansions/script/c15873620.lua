--人格面具-杰克灯笼
if not pcall(function() require("expansions/script/c15873611") end) then require("script/c15873611") end
local m=15873620
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsphh.SetCode(c,true)
	local e1=rsef.STO(c,EVENT_TO_GRAVE,{m,0},{1,m},"rm,se,th","de",cm.con,nil,rstg.target(rsop.list({Card.IsAbleToRemove,"rm"},{cm.thfilter,"th",LOCATION_DECK })),cm.thop)
end
function cm.con(e,tp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	return c:IsReason(REASON_SYNCHRO) and rc and rsphh.set2(rc)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and rsphh.stset(c)
end
function cm.thop(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c or Duel.Remove(c,POS_FACEUP,REASON_EFFECT)<=0 then return end
	rsof.SelectHint(tp,"th")
	local tg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
end 
