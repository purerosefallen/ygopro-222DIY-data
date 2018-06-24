--深界生物 泣尸鸟
function c33330008.initial_effect(c)
	--d a
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33330008,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DAMAGE_STEP_END)
	e4:SetCost(c33330008.cost)
	e4:SetCondition(c33330008.condition)
	e4:SetOperation(c33330008.operation)
	c:RegisterEffect(e4) 
	--rec
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33330008,1))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(aux.bdocon)
	e3:SetTarget(c33330008.attg)
	e3:SetOperation(c33330008.atop)
	c:RegisterEffect(e3)   
end
function c33330008.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x1019)>0 end
	Duel.SetTargetPlayer(tp)
	local ct=Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x1019)
	Duel.SetTargetParam(ct*100)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*100)
end
function c33330008.atop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c33330008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if chk==0 then return tc and tc:IsCode(33330019) and tc:IsFaceup() and tc:IsCanAddCounter(0x1009,1) end
	tc:AddCounter(0x1019,1)
end
function c33330008.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsChainAttackable() and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c33330008.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end