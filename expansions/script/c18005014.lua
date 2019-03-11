--迎击的拟魂
if not pcall(function() require("expansions/script/c18005001") end) then require("script/c18005001") end
local m=18005014
local cm=_G["c"..m]
cm.rssetcode="PseudoSoul"
function cm.initial_effect(c)
	local e1=rsef.ACT(c)  
	local e2=rsef.FTO(c,EVENT_ATTACK_ANNOUNCE,{m,0},nil,"sum",nil,LOCATION_SZONE,cm.con,nil,rstg.target(rsop.list(cm.sumfilter,"sum",LOCATION_HAND)),cm.sumop)
	local e3=rsps.TrapRemoveFun(c)
end
function cm.con(e,tp)
	return Duel.GetAttacker():IsControler(1-tp) and not Duel.GetAttackTarget()
end
function cm.sumfilter(c)
	return c:CheckSetCard("PseudoSoul") and c:IsSummonable(true,nil)
end
function cm.sumop(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end