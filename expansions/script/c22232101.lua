--爆炎反击
function c22232101.initial_effect(c)
	--Flag
	if not c22232101.global_check then
		c22232101.global_check=true
		c22232101[0]=true
		c22232101[1]=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetOperation(c22232101.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c22232101.clear)
		Duel.RegisterEffect(ge2,0)
	end
	--LaiPiGou
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22232101,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c22232101.condition)
	e1:SetCost(c22232101.cost)
	e1:SetTarget(c22232101.target)
	e1:SetOperation(c22232101.activate)
	c:RegisterEffect(e1)
	--act in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCondition(c22232101.actcon)
	c:RegisterEffect(e2)
end
function c22232101.IsValhalla(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Valhalla
end
function c22232101.confilter(c)
	return c:IsType(TYPE_MONSTER) and c22232101.IsValhalla(c) and (c:IsFaceup() or c:IsPreviousPosition(POS_FACEUP))
end
function c22232101.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:FilterCount(c22232101.confilter,nil)>0 then
		c22232101[rp]=true
	end
end
function c22232101.clear(e,tp,eg,ep,ev,re,r,rp)
	c22232101[0]=false
	c22232101[1]=false
end
function c22232101.condition(e,tp,eg,ep,ev,re,r,rp)
	return true
end
function c22232101.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c22232101.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22232101.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22232101.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
	if c22232101.IsValhalla(tc) then
		e:SetLabel(1)
	else 
		e:SetLabel(0)
	end
end
function c22232101.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c22232101.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() and e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetLabel()==1 then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
function c22232101.actcon(e)
	local tp=e:GetHandlerPlayer()
	return c22232101[tp]
end