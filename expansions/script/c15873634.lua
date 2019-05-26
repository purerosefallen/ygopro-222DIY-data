--偷心殿堂
if not pcall(function() require("expansions/script/c15873611") end) then require("script/c15873611") end
local m=15873634
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,nil,"lv",nil,cm.con,nil,nil,cm.activate)
	local e2=rsef.FTF(c,EVENT_PHASE+PHASE_STANDBY,{m,0},1,"lv,atk,def",nil,LOCATION_FZONE,cm.con3,nil,nil,cm.op)
	local e3=rsef.I(c,{m,1},{1,m},"sp,dish",nil,LOCATION_FZONE,cm.con,nil,cm.sptg,cm.spop)
	--local e4=rsef.QO(c,nil,{m,2},{1,m},nil,nil,LOCATION_FZONE,cm.con2,nil,nil,cm.attop)
end 
function cm.con3(e,tp)
	return cm.con(e,tp) and Duel.GetTurnPlayer()==tp
end
function cm.con2(e,tp)
	return cm.con(e,tp) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
end
function cm.attop(e,tp)
	local c=aux.ExceptThisCard(e)   
	if not c then return end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local attct=g:GetClassCount(Card.GetAttribute)
	local att=0xff
	if attct==1 then att=att-g:GetFirst():GetAttribute() end
	local att2=Duel.AnnounceAttribute(tp,1,att)
	for tc in aux.Next(g) do
		local e1=rsef.SV_CHANGE({e:GetHandler(),tc},"att",att2,nil,rsreset.est_pend)
	end
end
function cm.dishfilter(c,e,tp)
	return c:IsDiscardable(REASON_EFFECT) and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp,c)
end
function cm.spfilter1(c,e,tp,dc)
	return c:IsLevelAbove(2) and cm.cfilter(c) and Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,dc,e,tp,c:GetLevel())
end
function cm.spfilter2(c,e,tp,lv)
	return (rsphh.set(c) or rsphh.set2(c)) and c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.dishfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function cm.spop(e,tp)
	local c=aux.ExceptThisCard(e)   
	if not c then return end
	rsof.SelectHint(tp,"dish")
	local dc=Duel.SelectMatchingCard(tp,cm.dishfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if not dc or Duel.SendtoGrave(dc,REASON_DISCARD+REASON_EFFECT)<=0 then return end
	rsof.SelectHint(tp,HINTMSG_SELF)
	local dg=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp,dc)
	Duel.HintSelection(dg)  
	rsof.SelectHint(tp,"sp")
	local sc=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,dc,e,tp,dg:GetFirst():GetLevel()):GetFirst()
	if rssf.SpecialSummon(sc)>0 then
		Duel.BreakEffect()
		local lp=Duel.GetLP(tp)
		local llp=lp-(sc:GetLevel()*500)
		llp=math.max(0,llp)
		Duel.SetLP(tp,llp)
	end
end
function cm.cfilter(c)
	return c:IsFaceup() and (rsphh.set(c) or rsphh.set2(c))
end
function cm.con(e,tp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.activate(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		local e1=rsef.SV_UPDATE({c,tc},"lv",1,nil,rsreset.est)
	end
end
function cm.op(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		local e1,e2,e3=rsef.SV_UPDATE({c,tc},"lv,atk,def",{1,100,100},nil,rsreset.est)
	end
end