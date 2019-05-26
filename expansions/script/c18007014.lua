--幻量子涟漪
if not pcall(function() require("expansions/script/c18007001") end) then require("script/c18007001") end
local m=18007014
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,{m,0},nil,"td",nil,nil,nil,rstg.target(rsop.list(cm.tdfilter,"td",LOCATION_MZONE)),cm.tdop)
	local e2=rsef.FC(c,EVENT_SPSUMMON_SUCCESS,nil,nil,"de",LOCATION_SZONE,cm.tdcon1,cm.tdop1)
	local e3=rsef.FC(c,EVENT_SPSUMMON_SUCCESS,nil,nil,nil,LOCATION_SZONE,cm.tdcon2,cm.tdop2)
	local e4=rsef.FC(c,EVENT_CHAIN_SOLVED,nil,nil,nil,LOCATION_SZONE,cm.tdcon3,cm.tdop3)
	local e5=rsef.RegisterClone(c,e2,"code",EVENT_SUMMON_SUCCESS)
	local e6=rsef.RegisterClone(c,e3,"code",EVENT_SUMMON_SUCCESS)
end
cm.rssetcode="PhantomQuantum"
function cm.tdfilter(c)
	return c:CheckSetCard("PhantomQuantum") and c:IsAbleToDeck()
end
function cm.tdop(e,tp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	rsof.SelectHint(tp,"td")
	local tg=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if #tg>0 then
		Duel.HintSelection(tg)
		Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
	end 
end
function cm.tdcon1(e,tp,eg,ep,ev,re,r,rp)
	local sp=eg:GetFirst():GetSummonPlayer()
	return (not re or not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS)) and not Duel.IsPlayerAffectedByEffect(sp,EFFECT_IRON_WALL) and Duel.GetFieldGroupCount(sp,LOCATION_HAND+LOCATION_MZONE,0)>0
end
function cm.tdfilter2(c,tp)
	return c:IsType(TYPE_MONSTER) and Duel.IsPlayerCanSendtoDeck(tp,c)
end
function cm.tdop1(e,tp,eg,ep,ev,re,r,rp,p,n)
	local sp=p or eg:GetFirst():GetSummonPlayer()
	Duel.Hint(HINT_CARD,0,m)
	local g=Duel.GetFieldGroup(sp,LOCATION_HAND+LOCATION_MZONE,0)
	local ct=g:FilterCount(cm.tdfilter2,nil,sp)
	if not n then n=1 end
	local sct=math.min(ct,n)
	rsof.SelectHint(sp,"td")
	local sg=g:FilterSelect(sp,cm.tdfilter2,sct,sct,nil,sp)
	if #sg>0 then
		if sg:GetFirst():IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-sp,sg)
		else
			Duel.HintSelection(sg)
		end
		Duel.SendtoDeck(sg,nil,2,REASON_RULE)
	end
end
function cm.tdcon2(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function cm.tdop2(e,tp,eg,ep,ev,re,r,rp)
	local sp=eg:GetFirst():GetSummonPlayer()
	Duel.RegisterFlagEffect(sp,m,RESET_CHAIN,0,1)
end
function cm.tdcon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)>0 or Duel.GetFlagEffect(1-tp,m)>0
end
function cm.tdop3(e,tp,eg,ep,ev,re,r,rp)
	local list={tp,1-tp}
	for i=1,2 do
		local p=list[i]
		local n=Duel.GetFlagEffect(p,m)
		Duel.ResetFlagEffect(p,m)
		if n>0 then
			cm.tdop1(e,tp,eg,ep,ev,re,r,rp,p,n)
		end
	end
end

