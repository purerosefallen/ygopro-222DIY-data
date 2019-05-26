--心之怪盗团-伊戈尔
if not pcall(function() require("expansions/script/c15873611") end) then require("script/c15873611") end
local m=15873630
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsphh.SetCode(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(rscf.CheckLinkSetCard,"PhantomThievesOfHearts"),2)
	local e1=rsef.I(c,{m,0},{1,m},"sp",nil,LOCATION_MZONE,cm.con,cm.cost,rstg.target(rsop.list(cm.spfilter,"sp",LOCATION_EXTRA)),cm.spop)
	local e2=rsef.I(c,{m,1},{1,m+100},"se,th,rm",nil,LOCATION_GRAVE,nil,nil,rstg.target(rsop.list({Card.IsAbleToRemove,"rm"},{cm.rmfilter,"rm",LOCATION_GRAVE },{cm.thfilter,"th",LOCATION_DECK })),cm.thop)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SUMMON,cm.counterfilter)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.counterfilter)
end
function cm.rmfilter(c)
	return rsphh.mset(c) and c:IsAbleToRemove()
end
function cm.thfilter(c)
	return rsphh.mset(c) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	rsof.SelectHint(tp,"rm")
	local rg=Duel.SelectMatchingCard(tp,cm.rmfilter,tp,LOCATION_GRAVE,0,1,1,c)
	if #rg<=0 then return end
	rg:AddCard(c)
	if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)<=0 then return end
	rsof.SelectHint(tp,"th")
	local tg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function cm.counterfilter(c)
	return rsphh.set(c) or rsphh.set2(c)
end
function cm.con(e,tp)
	local g=e:GetHandler():GetMutualLinkedGroup()
	return g:IsExists(rscf.FilterFaceUp(rsphh.set),1,nil)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.sumlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (rsphh.set(c) or rsphh.set2(c))
end
function cm.spfilter(c,e,tp)
	local rc=e:GetHandler()
	local zone1=rc:GetLinkedZone(tp)
	return zone1>0 and rsphh.mset2(c) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone1)
end
function cm.spop(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	local zone1=c:GetLinkedZone(tp)
	rsof.SelectHint(tp,"sp")
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone1)
	end
end