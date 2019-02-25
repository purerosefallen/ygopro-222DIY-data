--生死轮舞 修妮贝卡·立法
if not pcall(function() require("expansions/script/c88946402") end) then require("script/c88946402") end
local m=88946405
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=rsef.QO(c,nil,{m,0},{1,m},nil,nil,LOCATION_PZONE,nil,rscost.reglabel(100),cm.copytg,cm.copyop)
	local e2,e7=rslrd.RitualFunction(c,m,true)
	local e3=rslrd.SummonLimitFunction(c)
	local e4=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,1},{1,m+100},"dis","tg,de",nil,nil,rstg.target({cm.disfilter,"dis",0,LOCATION_ONFIELD }),cm.disop)
	local e5=rsef.QO(c,nil,{m,1},{1,m+100},"th","tg",LOCATION_HAND,nil,rslrd.dishcost,rstg.target({cm.disfilter,"dis",0,LOCATION_ONFIELD }),cm.disop)
	local e6=rslrd.RemoveFunction(c)
	cm.pendlumeffect={e1,e2}
	cm.monstereffect={e5,e6}
end
function cm.disfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and aux.disfilter1(c)
end
function cm.disop(e,tp)
	local c=e:GetHandler()
	local tc=rscf.GetTargetCard()
	if not tc then return end
	if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_DISABLE)
		e4:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e4:SetTarget(cm.distg2)
		e4:SetLabel(tc:GetOriginalCode())
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_CHAIN_SOLVING)
		e5:SetCondition(cm.discon2)
		e5:SetOperation(cm.disop2)
		e5:SetLabel(tc:GetOriginalCode())
		e5:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e5,tp)
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
function cm.copyfilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not c.monstereffect or not c:IsSetCard(0x8964) or not c:IsType(TYPE_MONSTER) then return false end
	if c:IsLocation(LOCATION_REMOVED) and not c:IsFaceup() then return false end
	local e1=c.monstereffect[1]
	local e2=c.monstereffect[2]
	local target1=e1:GetTarget()
	local target2=nil
	if e2 then target2=e2:GetTarget() end
	if not target1 or target1(e,tp,eg,ep,ev,re,r,rp,0) then return true end
	if not e2 then return false end
	if not target2 or target2(e,tp,eg,ep,ev,re,r,rp,0) then return true end
	return false 
end
function cm.copytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabel()==100 and Duel.IsExistingMatchingCard(cm.copyfilter,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_REMOVED,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,cm.copyfilter,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_REMOVED,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp):GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	local e1=tc.monstereffect[1]
	local e2=tc.monstereffect[2]
	local target1=e1:GetTarget()
	local target2=nil
	if e2 then target2=e2:GetTarget() end
	local b1=not target1 or target1(e,tp,eg,ep,ev,re,r,rp,0)
	local b2=e2 and (not target2 or target2(e,tp,eg,ep,ev,re,r,rp,0))
	local desc2=0
	if e2 then desc2=e2:GetDescription() end
	local op=rsof.SelectOption(tp,b1,e1:GetDescription(),b2,desc2)
	local te=e2
	if op==1 then te=e1 end 
	Duel.ClearTargetCard()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	if not e:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
	   e:SetProperty(te:GetProperty()+EFFECT_FLAG_CARD_TARGET)
	end
	local tg=te:GetTarget()
	if tg then
	   tg(e,tp,eg,ep,ev,re,r,rp,1)
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
end
function cm.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
