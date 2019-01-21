--小黄
local m=12030022
local cm=_G["c"..m]
cm.rssetcode="yatori"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,cm.check)  
	local e1=rsef.QO(c,EVENT_CHAINING,{m,0},nil,"neg,des,dis","dcal,dsp",LOCATION_MZONE,rscon.negcon(3),rscost.cost({cm.cfilter,"res",LOCATION_MZONE }),rstg.negtg("des"),cm.negop)
	local e2=rsef.FTF(c,EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:RegisterSolve(cm.atkcon,nil,nil,cm.atkop)
	--disable spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTarget(cm.limittg)
	e3:SetTargetRange(1,1)
	c:RegisterEffect(e3)
end
function cm.limittg(e,c)
	if not c:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then return false end
	return c:IsType(TYPE_PENDULUM)
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.atkfilter,1,nil,re)
end
function cm.atkfilter(c,re)
	return c:CheckSetCard("yatori") and c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER) and c:IsAttackAbove(1)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(cm.atkfilter,nil,re)
	local atk=g:GetSum(Card.GetAttack)
	local e1=rsef.SV_UPDATE(c,"atk",atk,nil,rsreset.est+RESET_DISABLE)
	Duel.Recover(tp,atk,REASON_EFFECT)
end
function cm.check(g)
	return g:GetClassCount(Card.GetRace)==1
end
function cm.cfilter(c,e)
	return c:CheckSetCard("yatori") and e:GetHandler():GetLinkedGroup():IsContains(c)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local bool=rsop.negop("des")(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if bool and rc:IsType(TYPE_MONSTER) then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(cm.distg)
		e1:SetLabel(rc:GetOriginalCode())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(cm.discon)
		e2:SetOperation(cm.disop)
		e2:SetLabel(rc:GetOriginalCode())
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.distg(e,c)
	local code=e:GetLabel()
	local code1,code2=c:GetOriginalCodeRule()
	return code1==code or code2==code
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local code1,code2=re:GetHandler():GetOriginalCodeRule()
	return re:IsActiveType(TYPE_MONSTER) and (code1==code or code2==code)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
