--生死轮舞 索比琳特·宣判
if not pcall(function() require("expansions/script/c88946402") end) then require("script/c88946402") end
local m=88946406
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=rsef.QO(c,nil,{m,0},{1,m},"tg,te","tg",LOCATION_PZONE,nil,nil,rstg.target({aux.TRUE,"tg",LOCATION_REMOVED }),cm.tgop)
	local e2,e7=rslrd.RitualFunction(c,m,true)
	local e3=rslrd.SummonLimitFunction(c)
	local e4=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,1},{1,m+100},"dis","tg,de",nil,nil,rstg.target({cm.disfilter,"dis",0,LOCATION_GRAVE+LOCATION_MZONE }),cm.disop)
	local e5=rsef.QO(c,nil,{m,1},{1,m+100},"th","tg",LOCATION_HAND,nil,rslrd.dishcost,rstg.target({cm.disfilter,"dis",0,LOCATION_GRAVE+LOCATION_MZONE }),cm.disop)
	local e6=rslrd.RemoveFunction(c)
	cm.pendlumeffect={e1,e2}
	cm.monstereffect={e5,e6}
end
function cm.disfilter(c)
	return c:IsType(TYPE_MONSTER) and aux.disfilter1(c)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(cm.distg2)
		e1:SetLabel(tc:GetOriginalCode())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(cm.discon2)
		e2:SetOperation(cm.disop2)
		e2:SetLabel(tc:GetOriginalCode())
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.distg2(e,c)
	local code=e:GetLabel()
	local code1,code2=c:GetOriginalCodeRule()
	return code1==code or code2==code
end
function cm.discon2(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local code1,code2=re:GetHandler():GetOriginalCodeRule()
	return re:IsActiveType(TYPE_MONSTER) and (code1==code or code2==code)
end
function cm.disop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function cm.tgop(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	local tc=rscf.GetTargetCard()
	if not tc or Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)<=0 or not tc:IsLocation(LOCATION_GRAVE) or not tc:IsType(TYPE_MONSTER) or not tc:IsSetCard(0x8964) then return end
	local f=function(c)
		return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
	end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(f),tp,LOCATION_GRAVE,0,nil)
	if #g<=0 or not Duel.SelectYesNo(tp,aux.Stringid(m,2)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=g:Select(tp,1,1,nil)
	Duel.HintSelection(tg)  
	Duel.SendtoExtraP(tg,nil,REASON_EFFECT)
end
