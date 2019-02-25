--生死轮舞 坍塌的无限镜像
if not pcall(function() require("expansions/script/c88946402") end) then require("script/c88946402") end
local m=88946413
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e2=rsef.QO(c,nil,{m,0},{1,m},nil,nil,LOCATION_SZONE,cm.con,rscost.reglabel(100),cm.copytg,cm.copyop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(cm.chainop)
	c:RegisterEffect(e3)	
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsOriginalSetCard(0x8964) and re:GetHandler():GetOwner()==tp then
		Duel.SetChainLimit(cm.chainlm)
	end
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end
function cm.con(e,tp)
	return tp~=Duel.GetTurnPlayer()
end
function cm.copyfilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not c.pendlumeffect or not c:IsSetCard(0x8964) or not c:IsType(TYPE_PENDULUM) or not c:IsAbleToHandAsCost() then return false end
	local e1=c.pendlumeffect[1]
	local e2=c.pendlumeffect[2]
	local target1=e1:GetTarget()
	local target2=e2:GetTarget()
	if not target1 or target1(e,tp,eg,ep,ev,re,r,rp,0) then return true end
	if not target2 or target2(e,tp,eg,ep,ev,re,r,rp,0) then return true end
	return false 
end
function cm.copytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabel()==100 and Duel.IsExistingMatchingCard(cm.copyfilter,tp,LOCATION_PZONE,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,cm.copyfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp):GetFirst()
	Duel.SendtoHand(tc,nil,REASON_COST)
	local e1=tc.pendlumeffect[1]
	local e2=tc.pendlumeffect[2]
	local target1=e1:GetTarget()
	local target2=e2:GetTarget()
	local b1=not target1 or target1(e1,tp,eg,ep,ev,re,r,rp,0)
	local b2=not target2 or target2(e2,tp,eg,ep,ev,re,r,rp,0)
	local op=rsof.SelectOption(tp,b1,e1:GetDescription(),b2,e2:GetDescription())
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
	   tg(te,tp,eg,ep,ev,re,r,rp,1)
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	rscost[e]=tc:GetCode()
end
function cm.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	e:SetLabel(te:GetLabel())
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	local code=rscost[e]
	local g=Duel.GetMatchingGroup(cm.putfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,nil,code)
	if #g>0 and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function cm.putfilter(c,code)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x8964) and not c:IsCode(code)
end
