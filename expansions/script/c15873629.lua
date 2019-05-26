--心之怪盗团-卡罗琳 & 贾斯汀
if not pcall(function() require("expansions/script/c15873611") end) then require("script/c15873611") end
local m=15873629
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsphh.SetCode(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(rscf.CheckLinkSetCard,"PhantomThievesOfHearts"),2)
	local e1=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},{1,m},"se,th","de",rscon.sumtype("link"),nil,rstg.target(rsop.list(cm.thfilter2,"th",LOCATION_DECK)),cm.thop2)
	local e2=rsef.QO(c,EVENT_CHAINING,{m,1},{1,m+100},nil,nil,LOCATION_MZONE,cm.setcon,nil,rstg.target(rsop.list(cm.setfilter,nil,LOCATION_DECK)),cm.setop)
end
function cm.setfilter(c)
	return rsphh.stset(c) and c:IsSSetable()
end
function cm.setop(e,tp)
	rsof.SelectHint(tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if not tc then return end
	Duel.SSet(tp,tc)
	Duel.ConfirmCards(1-tp,tc)
	local e1=rsef.SV_LIMIT({e:GetHandler(),tc},"tri",nil,nil,rsreset.est_pend)
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	local loc,seq,p=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE,CHAININFO_TRIGGERING_CONTROLER)
	if p==1-tp then seq=seq+16 end
	return re:IsActiveType(TYPE_MONSTER) and bit.band(loc,LOCATION_MZONE)~=0 and bit.extract(c:GetLinkedZone(),seq)~=0 and Duel.IsChainNegatable(ev)
end
function cm.thfilter2(c)
	return c:IsAbleToHand() and rsphh.stset(c)
end
function cm.thop2(e,tp)
	rsof.SelectHint(tp,"th")
	local tg=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end